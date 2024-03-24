VERSION 5.00
Begin VB.Form frmkey 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Form1"
   ClientHeight    =   2805
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   6960
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2805
   ScaleWidth      =   6960
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command3 
      Caption         =   "Cari KOD"
      BeginProperty Font 
         Name            =   "Cambria"
         Size            =   11.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   240
      TabIndex        =   8
      Top             =   1800
      Width           =   6495
   End
   Begin VB.TextBox Text4 
      Alignment       =   2  'Center
      BeginProperty Font 
         Name            =   "Cambria"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   8160
      TabIndex        =   6
      Text            =   "Text4"
      Top             =   2880
      Visible         =   0   'False
      Width           =   3495
   End
   Begin VB.TextBox Text3 
      Alignment       =   2  'Center
      Appearance      =   0  'Flat
      BeginProperty Font 
         Name            =   "Cambria"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   465
      Left            =   2160
      TabIndex        =   4
      Text            =   "Text3"
      Top             =   960
      Width           =   4335
   End
   Begin VB.TextBox Text2 
      Height          =   375
      Left            =   8280
      TabIndex        =   3
      Text            =   "Text2"
      Top             =   2160
      Visible         =   0   'False
      Width           =   3495
   End
   Begin VB.TextBox Text1 
      Alignment       =   2  'Center
      Appearance      =   0  'Flat
      BeginProperty Font 
         Name            =   "Cambria"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   405
      Left            =   2160
      TabIndex        =   2
      Text            =   "Text1"
      Top             =   240
      Width           =   4335
   End
   Begin VB.ListBox List1 
      Height          =   840
      Left            =   7920
      TabIndex        =   1
      Top             =   1440
      Visible         =   0   'False
      Width           =   5175
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   615
      Left            =   9240
      TabIndex        =   0
      Top             =   240
      Visible         =   0   'False
      Width           =   1935
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "PENGESAHAN"
      BeginProperty Font 
         Name            =   "Cambria"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   240
      TabIndex        =   7
      Top             =   960
      Width           =   1695
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "KOD SISTEM "
      BeginProperty Font 
         Name            =   "Cambria"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   240
      TabIndex        =   5
      Top             =   240
      Width           =   1935
   End
End
Attribute VB_Name = "frmkey"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'Add a listbox  - name=list1
'Add a commanbutton - name=command1

Option Explicit
 
Private Const GENERIC_READ = &H80000000
Private Const GENERIC_WRITE = &H40000000
Private Const FILE_SHARE_READ = &H1
Private Const FILE_SHARE_WRITE = &H2
Private Const OPEN_EXISTING = 3
Private Const CREATE_NEW = 1
Private Const INVALID_HANDLE_VALUE = -1
Private Const VER_PLATFORM_WIN32_NT = 2
Private Const IDENTIFY_BUFFER_SIZE = 512
Private Const OUTPUT_DATA_SIZE = IDENTIFY_BUFFER_SIZE + 16

'GETVERSIONOUTPARAMS contains the data returned
'from the Get Driver Version function
Private Type GETVERSIONOUTPARAMS
   bVersion    As Byte 'Binary driver version.
   bRevision      As Byte 'Binary driver revision
   bReserved      As Byte 'Not used
   bIDEDeviceMap  As Byte 'Bit map of IDE devices
   fCapabilities  As Long 'Bit mask of driver capabilities
   dwReserved(3)  As Long 'For future use
End Type

'IDE registers
Private Type IDEREGS
   bFeaturesReg  As Byte 'Used for specifying SMART "commands"
   bSectorCountReg  As Byte 'IDE sector count register
   bSectorNumberReg As Byte 'IDE sector number register
   bCylLowReg      As Byte 'IDE low order cylinder value
   bCylHighReg    As Byte 'IDE high order cylinder value
   bDriveHeadReg    As Byte 'IDE drive/head register
   bCommandReg    As Byte 'Actual IDE command
   bReserved        As Byte 'reserved for future use - must be zero
End Type

'SENDCMDINPARAMS contains the input parameters for the
'Send Command to Drive function
Private Type SENDCMDINPARAMS
   cBufferSize   As Long     'Buffer size in bytes
   irDriveRegs   As IDEREGS  'Structure with drive register values.
   bDriveNumber As Byte  'Physical drive number to send command to (0,1,2,3).
   bReserved(2) As Byte  'Bytes reserved
   dwReserved(3)   As Long   'DWORDS reserved
   bBuffer()      As Byte     'Input buffer.
End Type

'Valid values for the bCommandReg member of IDEREGS.
Private Const IDE_ID_FUNCTION = &HEC            'Returns ID sector for ATA.
Private Const IDE_EXECUTE_SMART_FUNCTION = &HB0 'Performs SMART cmd.
                                                'Requires valid bFeaturesReg,
                                                'bCylLowReg, and bCylHighReg

'Cylinder register values required when issuing SMART command
Private Const SMART_CYL_LOW = &H4F
Private Const SMART_CYL_HI = &HC2

'Status returned from driver
Private Type DRIVERSTATUS
   bDriverError  As Byte          'Error code from driver, or 0 if no error
   bIDEStatus   As Byte       'Contents of IDE Error register
                                  'Only valid when bDriverError is SMART_IDE_ERROR
   bReserved(1)  As Byte
   dwReserved(1) As Long
 End Type

Private Type IDSECTOR
   wGenConfig                As Integer
   wNumCyls                As Integer
   wReserved                  As Integer
   wNumHeads                  As Integer
   wBytesPerTrack            As Integer
   wBytesPerSector          As Integer
   wSectorsPerTrack        As Integer
   wVendorUnique(2)        As Integer
   sSerialNumber(19)          As Byte
   wBufferType              As Integer
   wBufferSize              As Integer
   wECCSize                As Integer
   sFirmwareRev(7)          As Byte
   sModelNumber(39)        As Byte
   wMoreVendorUnique          As Integer
   wDoubleWordIO              As Integer
   wCapabilities              As Integer
   wReserved1                As Integer
   wPIOTiming                As Integer
   wDMATiming                As Integer
   wBS                      As Integer
   wNumCurrentCyls          As Integer
   wNumCurrentHeads        As Integer
   wNumCurrentSectorsPerTrack As Integer
   ulCurrentSectorCapacity  As Long
   wMultSectorStuff        As Integer
   ulTotalAddressableSectors  As Long
   wSingleWordDMA            As Integer
   wMultiWordDMA              As Integer
   bReserved(127)            As Byte
End Type

'Structure returned by SMART IOCTL commands
Private Type SENDCMDOUTPARAMS
  cBufferSize   As Long      'Size of Buffer in bytes
  DRIVERSTATUS  As DRIVERSTATUS 'Driver status structure
  bBuffer() As Byte       'Buffer of arbitrary length for data read from drive
End Type

'Vendor specific feature register defines
'for SMART "sub commands"
Private Const SMART_ENABLE_SMART_OPERATIONS = &HD8

'Status Flags Values
Public Enum STATUS_FLAGS
   PRE_FAILURE_WARRANTY = &H1
   ON_LINE_COLLECTION = &H2
   PERFORMANCE_ATTRIBUTE = &H4
   ERROR_RATE_ATTRIBUTE = &H8
   EVENT_COUNT_ATTRIBUTE = &H10
   SELF_PRESERVING_ATTRIBUTE = &H20
End Enum

'IOCTL commands
Private Const DFP_GET_VERSION = &H74080
Private Const DFP_SEND_DRIVE_COMMAND = &H7C084
Private Const DFP_RECEIVE_DRIVE_DATA = &H7C088

Private Type ATTR_DATA
   AttrID As Byte
   AttrName As String
   AttrValue As Byte
   ThresholdValue As Byte
   WorstValue As Byte
   StatusFlags As STATUS_FLAGS
End Type

Private Type DRIVE_INFO
   bDriveType As Byte
   SerialNumber As String
   Model As String
   FirmWare As String
   Cilinders As Long
   Heads As Long
   SecPerTrack As Long
   BytesPerSector As Long
   BytesperTrack As Long
   NumAttributes As Byte
   Attributes() As ATTR_DATA
End Type

Private Enum IDE_DRIVE_NUMBER
   PRIMARY_MASTER
   PRIMARY_SLAVE
   SECONDARY_MASTER
   SECONDARY_SLAVE
   TERTIARY_MASTER
   TERTIARY_SLAVE
   QUARTIARY_MASTER
   QUARTIARY_SLAVE
End Enum

Private Declare Function CreateFile Lib "kernel32" _
   Alias "CreateFileA" _
  (ByVal lpFileName As String, _
   ByVal dwDesiredAccess As Long, _
   ByVal dwShareMode As Long, _
   lpSecurityAttributes As Any, _
   ByVal dwCreationDisposition As Long, _
   ByVal dwFlagsAndAttributes As Long, _
   ByVal hTemplateFile As Long) As Long

Private Declare Function CloseHandle Lib "kernel32" _
  (ByVal hObject As Long) As Long
  
Private Declare Function DeviceIoControl Lib "kernel32" _
  (ByVal hDevice As Long, _
   ByVal dwIoControlCode As Long, _
   lpInBuffer As Any, _
   ByVal nInBufferSize As Long, _
   lpOutBuffer As Any, _
   ByVal nOutBufferSize As Long, _
   lpBytesReturned As Long, _
   lpOverlapped As Any) As Long
  
Private Declare Sub CopyMemory Lib "kernel32" _
   Alias "RtlMoveMemory" _
  (hpvDest As Any, _
   hpvSource As Any, _
   ByVal cbCopy As Long)
  
Private Type OSVERSIONINFO
   OSVSize As Long
   dwVerMajor As Long
   dwVerMinor As Long
   dwBuildNumber As Long
   PlatformID As Long
   szCSDVersion As String * 128
End Type

Private Declare Function GetVersionEx Lib "kernel32" _
   Alias "GetVersionExA" _
  (LpVersionInformation As OSVERSIONINFO) As Long



Private Sub Command2_Click()
If Text4.Text = Text3.Text Then MsgBox "BERJAYA" Else MsgBox "TIDAK BERJAYA"
End Sub

Private Sub Command3_Click()
Text1.Text = Trim$(Text1.Text)
Dim d, assk, assk1, caskara
Text2.Text = ""
Text1.SelLength = Len(Text1.Text)
d = 1
caskara = 0
Do Until d = Len(Text1.Text) + 1
 assk = Left(Text1.Text, d)
 assk1 = Right(assk, 1)
 
 If IsNumeric(assk1) = True Then Text2.Text = Text2.Text & assk1 Else caskara = caskara + 1

d = d + 1
Loop
If Len(caskara) <= 3 Then caskara = 15
If Len(caskara) = 5 Then caskara = 42
If Len(caskara) = 6 Then caskara = 21
If Len(caskara) >= 7 Then caskara = 89

Text2.Text = Text2.Text & Val(Len(Text1.Text) + caskara)
Text3.Text = Val((Text2.Text * 853996))
Text3.Text = "AHG-KSY" & Right(Val((Text2.Text * 853996)), 6)
End Sub

Private Sub Form_Load()
Call Command1_Click
End Sub


Private Sub Command1_Click()
List1.Clear
   Dim di As DRIVE_INFO
   Dim drvNumber As Long
   
      di = GetDriveInfo(0)

      List1.AddItem vbTab & "[0]"

               List1.AddItem vbTab & "Serial No:" & vbTab & Trim$(di.SerialNumber)
                Text1.Text = Trim$(di.SerialNumber)

Dim d, assk, assk1, caskara
Text2.Text = ""
Text1.SelLength = Len(Text1.Text)
d = 1
caskara = 0
Do Until d = Len(Text1.Text) + 1
 assk = Left(Text1.Text, d)
 assk1 = Right(assk, 1)
 
 If IsNumeric(assk1) = True Then Text2.Text = Text2.Text & assk1 Else caskara = caskara + 1

d = d + 1
Loop
If Len(caskara) <= 3 Then caskara = 15
If Len(caskara) = 5 Then caskara = 42
If Len(caskara) = 6 Then caskara = 21
If Len(caskara) >= 7 Then caskara = 89

Text2.Text = Text2.Text & Val(Len(Text1.Text) + caskara)
Text3.Text = Val((Text2.Text * 853996))
Text3.Text = "AHG-KSY" & Right(Val((Text2.Text * 853996)), 6)
End Sub


Private Function GetDriveInfo(drvNumber As IDE_DRIVE_NUMBER) As DRIVE_INFO
    
   Dim hDrive As Long
   Dim di As DRIVE_INFO
   
   hDrive = SmartOpen(drvNumber)
   
   If hDrive <> INVALID_HANDLE_VALUE Then
   
      If SmartGetVersion(hDrive) = True Then
      
         With di
            .bDriveType = 0
            .NumAttributes = 0
            ReDim .Attributes(0)
            .bDriveType = 1
         End With
         
         If SmartCheckEnabled(hDrive, drvNumber) Then
            
            If IdentifyDrive(hDrive, IDE_ID_FUNCTION, drvNumber, di) = True Then
         
               GetDriveInfo = di
               
            End If   'IdentifyDrive
         End If   'SmartCheckEnabled
      End If   'SmartGetVersion
   End If   'hDrive <> INVALID_HANDLE_VALUE
   
   CloseHandle hDrive
   
End Function


Private Function IdentifyDrive(ByVal hDrive As Long, _
                               ByVal IDCmd As Byte, _
                               ByVal drvNumber As IDE_DRIVE_NUMBER, _
                               di As DRIVE_INFO) As Boolean
    
  'Function: Send an IDENTIFY command to the drive
  'drvNumber = 0-3
  'IDCmd = IDE_ID_FUNCTION or IDE_ATAPI_ID
   Dim SCIP As SENDCMDINPARAMS
   Dim IDSEC As IDSECTOR
   Dim bArrOut(OUTPUT_DATA_SIZE - 1) As Byte
   Dim cbBytesReturned As Long
   
   With SCIP
      .cBufferSize = IDENTIFY_BUFFER_SIZE
      .bDriveNumber = CByte(drvNumber)
        
      With .irDriveRegs
         .bFeaturesReg = 0
         .bSectorCountReg = 1
         .bSectorNumberReg = 1
         .bCylLowReg = 0
         .bCylHighReg = 0
         .bDriveHeadReg = &HA0 'compute the drive number
         If Not IsWinNT4Plus Then
            .bDriveHeadReg = .bDriveHeadReg Or ((drvNumber And 1) * 16)
         End If
         'the command can either be IDE
         'identify or ATAPI identify.
         .bCommandReg = CByte(IDCmd)
      End With
   End With
   
   If DeviceIoControl(hDrive, _
                      DFP_RECEIVE_DRIVE_DATA, _
                      SCIP, _
                      Len(SCIP) - 4, _
                      bArrOut(0), _
                      OUTPUT_DATA_SIZE, _
                      cbBytesReturned, _
                      ByVal 0&) Then
                      
      CopyMemory IDSEC, bArrOut(16), Len(IDSEC)

      di.Model = StrConv(SwapBytes(IDSEC.sModelNumber), vbUnicode)
      di.SerialNumber = StrConv(SwapBytes(IDSEC.sSerialNumber), vbUnicode)
      
      IdentifyDrive = True
      
    End If
    
End Function


Private Function IsWinNT4Plus() As Boolean

  'returns True if running Windows NT4 or later
   Dim osv As OSVERSIONINFO

   osv.OSVSize = Len(osv)

   If GetVersionEx(osv) = 1 Then
   
      IsWinNT4Plus = (osv.PlatformID = VER_PLATFORM_WIN32_NT) And _
                     (osv.dwVerMajor >= 4)
 
   End If

End Function


Private Function SmartCheckEnabled(ByVal hDrive As Long, _
                                   drvNumber As IDE_DRIVE_NUMBER) As Boolean
   
  'SmartCheckEnabled - Check if SMART enable
  'FUNCTION: Send a SMART_ENABLE_SMART_OPERATIONS command to the drive
  'bDriveNum = 0-3
   Dim SCIP As SENDCMDINPARAMS
   Dim SCOP As SENDCMDOUTPARAMS
   Dim cbBytesReturned As Long
   
   With SCIP
   
      .cBufferSize = 0
      
      With .irDriveRegs
           .bFeaturesReg = SMART_ENABLE_SMART_OPERATIONS
           .bSectorCountReg = 1
           .bSectorNumberReg = 1
           .bCylLowReg = SMART_CYL_LOW
           .bCylHighReg = SMART_CYL_HI

           .bDriveHeadReg = &HA0
            If Not IsWinNT4Plus Then
               .bDriveHeadReg = .bDriveHeadReg Or ((drvNumber And 1) * 16)
            End If
           .bCommandReg = IDE_EXECUTE_SMART_FUNCTION
           
       End With
       
       .bDriveNumber = drvNumber
       
   End With
   
   SmartCheckEnabled = DeviceIoControl(hDrive, _
                                      DFP_SEND_DRIVE_COMMAND, _
                                      SCIP, _
                                      Len(SCIP) - 4, _
                                      SCOP, _
                                      Len(SCOP) - 4, _
                                      cbBytesReturned, _
                                      ByVal 0&)
End Function


Private Function SmartGetVersion(ByVal hDrive As Long) As Boolean
   
   Dim cbBytesReturned As Long
   Dim GVOP As GETVERSIONOUTPARAMS
   
   SmartGetVersion = DeviceIoControl(hDrive, _
                                     DFP_GET_VERSION, _
                                     ByVal 0&, 0, _
                                     GVOP, _
                                     Len(GVOP), _
                                     cbBytesReturned, _
                                     ByVal 0&)
   
End Function


Private Function SmartOpen(drvNumber As IDE_DRIVE_NUMBER) As Long

  'Open SMART to allow DeviceIoControl
  'communications and return SMART handle

   If IsWinNT4Plus() Then
      
      SmartOpen = CreateFile("\\.\PhysicalDrive" & CStr(drvNumber), _
                             GENERIC_READ Or GENERIC_WRITE, _
                             FILE_SHARE_READ Or FILE_SHARE_WRITE, _
                             ByVal 0&, _
                             OPEN_EXISTING, _
                             0&, _
                             0&)

   Else
      
      SmartOpen = CreateFile("\\.\SMARTVSD", _
                              0&, 0&, _
                              ByVal 0&, _
                              CREATE_NEW, _
                              0&, _
                              0&)
   End If
   
End Function


Private Function SwapBytes(b() As Byte) As Byte()
   
   
   Dim bTemp As Byte
   Dim cnt As Long

   For cnt = LBound(b) To UBound(b) Step 2
      bTemp = b(cnt)
      b(cnt) = b(cnt + 1)
      b(cnt + 1) = bTemp
   Next cnt
      
   SwapBytes = b()
      
End Function

Private Sub Form_Unload(Cancel As Integer)
End
End Sub
