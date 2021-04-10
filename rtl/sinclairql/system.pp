{
    This file is part of the Free Pascal run time library.
    Copyright (c) 2020 by Karoly Balogh

    System unit for the Sinclair QL

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit System;

interface

{$define FPC_IS_SYSTEM}
{$define FPC_STDOUT_TRUE_ALIAS}
{$define FPC_ANSI_TEXTFILEREC}
{$define FPC_QL_USE_OSHEAP}

{$ifdef FPC_QL_USE_OSHEAP}
{$define HAS_MEMORYMANAGER}
{$endif FPC_QL_USE_OSHEAP}

{$i systemh.inc}

{Platform specific information}
const
    LineEnding = #10;
    LFNSupport = false;
    CtrlZMarksEOF: boolean = false; (* #26 not considered as end of file *)
    DirectorySeparator = '\';
    DriveSeparator = ':';
    ExtensionSeparator = '.';
    PathSeparator = ';';
    AllowDirectorySeparators : set of char = ['\','/'];
    AllowDriveSeparators : set of char = [':'];
    FileNameCaseSensitive = false;
    FileNameCasePreserving = false;
    maxExitCode = 255;
    MaxPathLen = 255;
    AllFilesMask = '*.*';

    sLineBreak = LineEnding;
    DefaultTextLineBreakStyle : TTextLineBreakStyle = tlbsLF;

const
    UnusedHandle    = -1;
    StdInputHandle: longint = UnusedHandle;
    StdOutputHandle: longint = UnusedHandle;
    StdErrorHandle: longint = UnusedHandle;

var
    QL_ChannelIDNum : word;
    QL_ChannelIDs: pdword;
    QL_CommandLineLen : word;
    QL_CommandLine : pchar;

    argv: PPChar;
    argc: Longint;

    {$if defined(FPUSOFT)}

    {$define fpc_softfpu_interface}
    {$i softfpu.pp}
    {$undef fpc_softfpu_interface}

    {$endif defined(FPUSOFT)}


implementation

  {$if defined(FPUSOFT)}

  {$define fpc_softfpu_implementation}
  {$define softfpu_compiler_mul32to64}
  {$define softfpu_inline}
  {$i softfpu.pp}
  {$undef fpc_softfpu_implementation}

  { we get these functions and types from the softfpu code }
  {$define FPC_SYSTEM_HAS_float64}
  {$define FPC_SYSTEM_HAS_float32}
  {$define FPC_SYSTEM_HAS_flag}
  {$define FPC_SYSTEM_HAS_extractFloat64Frac0}
  {$define FPC_SYSTEM_HAS_extractFloat64Frac1}
  {$define FPC_SYSTEM_HAS_extractFloat64Exp}
  {$define FPC_SYSTEM_HAS_extractFloat64Sign}
  {$define FPC_SYSTEM_HAS_ExtractFloat32Frac}
  {$define FPC_SYSTEM_HAS_extractFloat32Exp}
  {$define FPC_SYSTEM_HAS_extractFloat32Sign}

  {$endif defined(FPUSOFT)}

  {$i system.inc}
  {$ifdef FPC_QL_USE_OSHEAP}
  {$i osheap.inc}
  {$endif FPC_QL_USE_OSHEAP}


function GetProcessID:SizeUInt;
begin
  GetProcessID := mt_inf(nil, nil);
end;

{*****************************************************************************
                             ParamStr
*****************************************************************************}

var
  args: PChar;

{ number of args }
function ParamCount: LongInt;
begin
  ParamCount:=argc;
end;

{ argument number l }
function ParamStr(l: LongInt): string;
begin
  if (l >= 0) and (l <= argc) then
    ParamStr:=argv[l]
  else
    ParamStr:='';
end;

procedure SysInitParamsAndEnv;
var
  i,j : longint;
  c : char;
  argv_size : longint;
const
  word_separators=[' ',#0];
begin
  argc:=0;
  argv:=nil;
  args:=GetMem(QL_CommandLineLen+1);
  if not assigned(args) then
    exit;

  Move(QL_CommandLine^,args^,QL_CommandLineLen);
  args[QL_CommandLineLen]:=#0;

  i:=0;
  c:=' ';
  while args[i]<>#0 do
    begin
      if (c in word_separators) and not (args[i] in word_separators) then
        inc(argc);
      c:=args[i];
      inc(i);
    end;

  { +2 is because argv[0] should be program name, 
    and argv[argc+1] is argv array terminator }
  argv:=GetMem((argc+2)*sizeof(pointer));
  if not assigned(argv) then
    begin
      argc:=0;
      exit;
    end;
  argv[argc+1]:=nil;
  { FIX ME: for now the 0th argument (program name) is just always empty }
  argv[0]:=#0;

  i:=0;
  j:=1;
  c:=' ';
  while args[i]<>#0 do
    begin
      if (c in word_separators) and not (args[i] in word_separators) then
        begin
          argv[j]:=@args[i];
          inc(j);
        end;
      c:=args[i];
      if (c in word_separators) then
        args[i]:=#0;
      inc(i);
    end;
end;

procedure randomize;
begin
  { Get the current date/time }
  randseed:=mt_rclck;
end;

procedure PrintStr(ch: longint; const s: shortstring);
begin
  io_sstrg(ch,-1,@s[1],ord(s[0]));
end;

procedure DebugStr(const s: shortstring); public name '_dbgstr';
var
  i: longint;
begin
  PrintStr(stdOutputHandle,s);
  for i:=0 to 10000 do begin end;
end;


{*****************************************************************************
                        System Dependent Entry code
*****************************************************************************}
var
  jobStackDataPtr: pointer; external name '__job_stack_data_ptr';

{ QL/QDOS specific startup }
procedure SysInitQDOS;
var
  r: TQLRect;
begin
  QL_ChannelIDNum:=pword(jobStackDataPtr)[0];
  QL_ChannelIDs:=@pword(jobStackDataPtr)[1];
  QL_CommandLineLen:=pword(@QL_ChannelIDs[QL_ChannelIDNum])[0];
  QL_CommandLine:=@pword(@QL_ChannelIDs[QL_ChannelIDNum])[1];

  stdInputHandle:=io_open('con_',Q_OPEN);
  stdOutputHandle:=stdInputHandle;
  stdErrorHandle:=stdInputHandle;

  r.q_width:=512;
  r.q_height:=256;
  r.q_x:=0;
  r.q_y:=0;

  sd_wdef(stdInputHandle,-1,2,1,@r);
  sd_clear(stdInputHandle,-1);
end;

{*****************************************************************************
                         System Dependent Exit code
*****************************************************************************}

procedure haltproc(e:longint); external name '_haltproc';

procedure system_exit;
const
  anyKey: string = 'Press any key to exit';
begin
  if assigned(args) then
    FreeMem(args);
  if assigned(argv) then
    FreeMem(argv);

  io_sstrg(stdOutputHandle, -1, @anyKey[1], ord(anyKey[0]));
  io_fbyte(stdInputHandle, -1);

  stdInputHandle:=UnusedHandle;
  stdOutputHandle:=UnusedHandle;
  stdErrorHandle:=UnusedHandle;
  haltproc(exitcode);
end;

{*****************************************************************************
                         System Unit Initialization
*****************************************************************************}

procedure SysInitStdIO;
begin
  OpenStdIO(Input,fmInput,StdInputHandle);
  OpenStdIO(Output,fmOutput,StdOutputHandle);
  OpenStdIO(ErrOutput,fmOutput,StdErrorHandle);
{$ifndef FPC_STDOUT_TRUE_ALIAS}
  OpenStdIO(StdOut,fmOutput,StdOutputHandle);
  OpenStdIO(StdErr,fmOutput,StdErrorHandle);
{$endif FPC_STDOUT_TRUE_ALIAS}
end;

function CheckInitialStkLen (StkLen: SizeUInt): SizeUInt;
begin
  CheckInitialStkLen := StkLen;
end;


begin
  StackLength := CheckInitialStkLen (InitialStkLen);
{ Initialize ExitProc }
  ExitProc:=Nil;
  SysInitQDOS;
{$ifndef FPC_QL_USE_OSHEAP}
{ Setup heap }
  InitHeap;
{$else FPC_QL_USE_OSHEAP}
//  InitOSHeap;
{$endif FPC_QL_USE_OSHEAP}
  SysInitExceptions;
{$ifdef FPC_HAS_FEATURE_UNICODESTRINGS}
  InitUnicodeStringManager;
{$endif FPC_HAS_FEATURE_UNICODESTRINGS}
{ Setup stdin, stdout and stderr }
  SysInitStdIO;
{ Reset IO Error }
  InOutRes:=0;
{ Setup command line arguments }
  SysInitParamsAndEnv;
{$ifdef FPC_HAS_FEATURE_THREADING}
  InitSystemThreads;
{$endif FPC_HAS_FEATURE_THREADING}
end.
