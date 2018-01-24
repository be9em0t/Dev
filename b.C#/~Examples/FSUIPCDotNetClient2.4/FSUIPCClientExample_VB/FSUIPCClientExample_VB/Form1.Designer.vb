<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Form1
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing AndAlso components IsNot Nothing Then
            components.Dispose()
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Me.Timer1 = New System.Windows.Forms.Timer(Me.components)
        Me.chkPause = New System.Windows.Forms.CheckBox
        Me.label6 = New System.Windows.Forms.Label
        Me.label5 = New System.Windows.Forms.Label
        Me.chkCabin = New System.Windows.Forms.CheckBox
        Me.chkLogo = New System.Windows.Forms.CheckBox
        Me.chkWing = New System.Windows.Forms.CheckBox
        Me.chkRecognition = New System.Windows.Forms.CheckBox
        Me.chkTaxi = New System.Windows.Forms.CheckBox
        Me.chkInstuments = New System.Windows.Forms.CheckBox
        Me.chkLanding = New System.Windows.Forms.CheckBox
        Me.chkStrobes = New System.Windows.Forms.CheckBox
        Me.chkBeacon = New System.Windows.Forms.CheckBox
        Me.chkAvionics = New System.Windows.Forms.CheckBox
        Me.chkNavigation = New System.Windows.Forms.CheckBox
        Me.btnReconnectOnce = New System.Windows.Forms.Button
        Me.btnReconnect = New System.Windows.Forms.Button
        Me.btnDisconnectAfterNext = New System.Windows.Forms.Button
        Me.btnDisconnect = New System.Windows.Forms.Button
        Me.btnGetAircraftType = New System.Windows.Forms.Button
        Me.txtAircraftType = New System.Windows.Forms.TextBox
        Me.txtFSDateTime = New System.Windows.Forms.TextBox
        Me.txtCompass = New System.Windows.Forms.TextBox
        Me.txtIAS = New System.Windows.Forms.TextBox
        Me.label4 = New System.Windows.Forms.Label
        Me.label2 = New System.Windows.Forms.Label
        Me.label3 = New System.Windows.Forms.Label
        Me.label7 = New System.Windows.Forms.Label
        Me.label1 = New System.Windows.Forms.Label
        Me.btnStart = New System.Windows.Forms.Button
        Me.txtCOM2 = New System.Windows.Forms.TextBox
        Me.label8 = New System.Windows.Forms.Label
        Me.TabControl1 = New System.Windows.Forms.TabControl
        Me.TabPage1 = New System.Windows.Forms.TabPage
        Me.TabPage2 = New System.Windows.Forms.TabPage
        Me.btnMoveToEGLL = New System.Windows.Forms.Button
        Me.chkPlaneOnRunway = New System.Windows.Forms.CheckBox
        Me.txtBearing = New System.Windows.Forms.TextBox
        Me.cbxDistanceUnits = New System.Windows.Forms.ComboBox
        Me.txtDistance = New System.Windows.Forms.TextBox
        Me.label18 = New System.Windows.Forms.Label
        Me.txtLongitude = New System.Windows.Forms.TextBox
        Me.txtLatitude = New System.Windows.Forms.TextBox
        Me.label17 = New System.Windows.Forms.Label
        Me.TabPage3 = New System.Windows.Forms.TabPage
        Me.Label9 = New System.Windows.Forms.Label
        Me.chkShowGroundAI = New System.Windows.Forms.CheckBox
        Me.chkShowAirborneAI = New System.Windows.Forms.CheckBox
        Me.cbxRadarRange = New System.Windows.Forms.ComboBox
        Me.chkEnableAIRadar = New System.Windows.Forms.CheckBox
        Me.AIRadarTimer = New System.Windows.Forms.Timer(Me.components)
        Me.Label10 = New System.Windows.Forms.Label
        Me.pnlAIRadar = New FSUIPCClientExample_VB.DoubleBufferPanel
        Me.TabControl1.SuspendLayout()
        Me.TabPage1.SuspendLayout()
        Me.TabPage2.SuspendLayout()
        Me.TabPage3.SuspendLayout()
        Me.SuspendLayout()
        '
        'Timer1
        '
        '
        'chkPause
        '
        Me.chkPause.AutoSize = True
        Me.chkPause.Location = New System.Drawing.Point(210, 491)
        Me.chkPause.Name = "chkPause"
        Me.chkPause.Size = New System.Drawing.Size(56, 17)
        Me.chkPause.TabIndex = 33
        Me.chkPause.Text = "Pause"
        Me.chkPause.UseVisualStyleBackColor = True
        '
        'label6
        '
        Me.label6.Location = New System.Drawing.Point(6, 396)
        Me.label6.Name = "label6"
        Me.label6.Size = New System.Drawing.Size(137, 48)
        Me.label6.TabIndex = 31
        Me.label6.Text = "Compass heading: (Example of disconnecting an offset an Offset)"
        '
        'label5
        '
        Me.label5.Location = New System.Drawing.Point(6, 489)
        Me.label5.Name = "label5"
        Me.label5.Size = New System.Drawing.Size(168, 39)
        Me.label5.TabIndex = 32
        Me.label5.Text = "Pause control.  (Example of a write only Offset)"
        '
        'chkCabin
        '
        Me.chkCabin.AutoSize = True
        Me.chkCabin.Location = New System.Drawing.Point(339, 358)
        Me.chkCabin.Name = "chkCabin"
        Me.chkCabin.Size = New System.Drawing.Size(53, 17)
        Me.chkCabin.TabIndex = 23
        Me.chkCabin.Text = "Cabin"
        Me.chkCabin.UseVisualStyleBackColor = True
        '
        'chkLogo
        '
        Me.chkLogo.AutoSize = True
        Me.chkLogo.Location = New System.Drawing.Point(339, 335)
        Me.chkLogo.Name = "chkLogo"
        Me.chkLogo.Size = New System.Drawing.Size(50, 17)
        Me.chkLogo.TabIndex = 24
        Me.chkLogo.Text = "Logo"
        Me.chkLogo.UseVisualStyleBackColor = True
        '
        'chkWing
        '
        Me.chkWing.AutoSize = True
        Me.chkWing.Location = New System.Drawing.Point(339, 312)
        Me.chkWing.Name = "chkWing"
        Me.chkWing.Size = New System.Drawing.Size(51, 17)
        Me.chkWing.TabIndex = 22
        Me.chkWing.Text = "Wing"
        Me.chkWing.UseVisualStyleBackColor = True
        '
        'chkRecognition
        '
        Me.chkRecognition.AutoSize = True
        Me.chkRecognition.Location = New System.Drawing.Point(339, 289)
        Me.chkRecognition.Name = "chkRecognition"
        Me.chkRecognition.Size = New System.Drawing.Size(83, 17)
        Me.chkRecognition.TabIndex = 20
        Me.chkRecognition.Text = "Recognition"
        Me.chkRecognition.UseVisualStyleBackColor = True
        '
        'chkTaxi
        '
        Me.chkTaxi.AutoSize = True
        Me.chkTaxi.Location = New System.Drawing.Point(206, 335)
        Me.chkTaxi.Name = "chkTaxi"
        Me.chkTaxi.Size = New System.Drawing.Size(46, 17)
        Me.chkTaxi.TabIndex = 21
        Me.chkTaxi.Text = "Taxi"
        Me.chkTaxi.UseVisualStyleBackColor = True
        '
        'chkInstuments
        '
        Me.chkInstuments.AutoSize = True
        Me.chkInstuments.Location = New System.Drawing.Point(339, 266)
        Me.chkInstuments.Name = "chkInstuments"
        Me.chkInstuments.Size = New System.Drawing.Size(80, 17)
        Me.chkInstuments.TabIndex = 25
        Me.chkInstuments.Text = "Instruments"
        Me.chkInstuments.UseVisualStyleBackColor = True
        '
        'chkLanding
        '
        Me.chkLanding.AutoSize = True
        Me.chkLanding.Location = New System.Drawing.Point(206, 312)
        Me.chkLanding.Name = "chkLanding"
        Me.chkLanding.Size = New System.Drawing.Size(64, 17)
        Me.chkLanding.TabIndex = 29
        Me.chkLanding.Text = "Landing"
        Me.chkLanding.UseVisualStyleBackColor = True
        '
        'chkStrobes
        '
        Me.chkStrobes.AutoSize = True
        Me.chkStrobes.Location = New System.Drawing.Point(206, 359)
        Me.chkStrobes.Name = "chkStrobes"
        Me.chkStrobes.Size = New System.Drawing.Size(62, 17)
        Me.chkStrobes.TabIndex = 30
        Me.chkStrobes.Text = "Strobes"
        Me.chkStrobes.UseVisualStyleBackColor = True
        '
        'chkBeacon
        '
        Me.chkBeacon.AutoSize = True
        Me.chkBeacon.Location = New System.Drawing.Point(206, 289)
        Me.chkBeacon.Name = "chkBeacon"
        Me.chkBeacon.Size = New System.Drawing.Size(63, 17)
        Me.chkBeacon.TabIndex = 28
        Me.chkBeacon.Text = "Beacon"
        Me.chkBeacon.UseVisualStyleBackColor = True
        '
        'chkAvionics
        '
        Me.chkAvionics.AutoSize = True
        Me.chkAvionics.Location = New System.Drawing.Point(206, 99)
        Me.chkAvionics.Name = "chkAvionics"
        Me.chkAvionics.Size = New System.Drawing.Size(15, 14)
        Me.chkAvionics.TabIndex = 26
        Me.chkAvionics.UseVisualStyleBackColor = True
        '
        'chkNavigation
        '
        Me.chkNavigation.AutoSize = True
        Me.chkNavigation.Location = New System.Drawing.Point(206, 266)
        Me.chkNavigation.Name = "chkNavigation"
        Me.chkNavigation.Size = New System.Drawing.Size(77, 17)
        Me.chkNavigation.TabIndex = 27
        Me.chkNavigation.Text = "Navigation"
        Me.chkNavigation.UseVisualStyleBackColor = True
        '
        'btnReconnectOnce
        '
        Me.btnReconnectOnce.Location = New System.Drawing.Point(289, 450)
        Me.btnReconnectOnce.Name = "btnReconnectOnce"
        Me.btnReconnectOnce.Size = New System.Drawing.Size(165, 25)
        Me.btnReconnectOnce.TabIndex = 16
        Me.btnReconnectOnce.Text = "Reconnect for one Process()"
        Me.btnReconnectOnce.UseVisualStyleBackColor = True
        '
        'btnReconnect
        '
        Me.btnReconnect.Location = New System.Drawing.Point(206, 450)
        Me.btnReconnect.Name = "btnReconnect"
        Me.btnReconnect.Size = New System.Drawing.Size(77, 25)
        Me.btnReconnect.TabIndex = 15
        Me.btnReconnect.Text = "Reconnect"
        Me.btnReconnect.UseVisualStyleBackColor = True
        '
        'btnDisconnectAfterNext
        '
        Me.btnDisconnectAfterNext.Location = New System.Drawing.Point(289, 421)
        Me.btnDisconnectAfterNext.Name = "btnDisconnectAfterNext"
        Me.btnDisconnectAfterNext.Size = New System.Drawing.Size(165, 23)
        Me.btnDisconnectAfterNext.TabIndex = 17
        Me.btnDisconnectAfterNext.Text = "Disconnect after next Process()"
        Me.btnDisconnectAfterNext.UseVisualStyleBackColor = True
        '
        'btnDisconnect
        '
        Me.btnDisconnect.Location = New System.Drawing.Point(206, 422)
        Me.btnDisconnect.Name = "btnDisconnect"
        Me.btnDisconnect.Size = New System.Drawing.Size(77, 22)
        Me.btnDisconnect.TabIndex = 19
        Me.btnDisconnect.Text = "Disconnect"
        Me.btnDisconnect.UseVisualStyleBackColor = True
        '
        'btnGetAircraftType
        '
        Me.btnGetAircraftType.Location = New System.Drawing.Point(162, 206)
        Me.btnGetAircraftType.Name = "btnGetAircraftType"
        Me.btnGetAircraftType.Size = New System.Drawing.Size(38, 23)
        Me.btnGetAircraftType.TabIndex = 18
        Me.btnGetAircraftType.Text = "Get"
        Me.btnGetAircraftType.UseVisualStyleBackColor = True
        '
        'txtAircraftType
        '
        Me.txtAircraftType.Location = New System.Drawing.Point(206, 206)
        Me.txtAircraftType.Name = "txtAircraftType"
        Me.txtAircraftType.ReadOnly = True
        Me.txtAircraftType.Size = New System.Drawing.Size(245, 20)
        Me.txtAircraftType.TabIndex = 12
        '
        'txtFSDateTime
        '
        Me.txtFSDateTime.Location = New System.Drawing.Point(209, 171)
        Me.txtFSDateTime.Name = "txtFSDateTime"
        Me.txtFSDateTime.ReadOnly = True
        Me.txtFSDateTime.Size = New System.Drawing.Size(245, 20)
        Me.txtFSDateTime.TabIndex = 11
        '
        'txtCompass
        '
        Me.txtCompass.Location = New System.Drawing.Point(206, 396)
        Me.txtCompass.Name = "txtCompass"
        Me.txtCompass.ReadOnly = True
        Me.txtCompass.Size = New System.Drawing.Size(59, 20)
        Me.txtCompass.TabIndex = 14
        '
        'txtIAS
        '
        Me.txtIAS.Location = New System.Drawing.Point(206, 54)
        Me.txtIAS.Name = "txtIAS"
        Me.txtIAS.ReadOnly = True
        Me.txtIAS.Size = New System.Drawing.Size(59, 20)
        Me.txtIAS.TabIndex = 13
        '
        'label4
        '
        Me.label4.Location = New System.Drawing.Point(6, 266)
        Me.label4.Name = "label4"
        Me.label4.Size = New System.Drawing.Size(137, 51)
        Me.label4.TabIndex = 7
        Me.label4.Text = "Lights: (Example of using a BitArray for a bitmap type offset)"
        '
        'label2
        '
        Me.label2.Location = New System.Drawing.Point(6, 206)
        Me.label2.Name = "label2"
        Me.label2.Size = New System.Drawing.Size(137, 51)
        Me.label2.TabIndex = 6
        Me.label2.Text = "Aircraft Type: (Example of string read and different offset group)"
        '
        'label3
        '
        Me.label3.Location = New System.Drawing.Point(9, 171)
        Me.label3.Name = "label3"
        Me.label3.Size = New System.Drawing.Size(194, 20)
        Me.label3.TabIndex = 8
        Me.label3.Text = "FS Date/Time (Array Read)"
        '
        'label7
        '
        Me.label7.Location = New System.Drawing.Point(6, 94)
        Me.label7.Name = "label7"
        Me.label7.Size = New System.Drawing.Size(194, 37)
        Me.label7.TabIndex = 10
        Me.label7.Text = "Master Avionic Switch.  (Example of basic Integer read and write)"
        '
        'label1
        '
        Me.label1.Location = New System.Drawing.Point(6, 57)
        Me.label1.Name = "label1"
        Me.label1.Size = New System.Drawing.Size(194, 37)
        Me.label1.TabIndex = 9
        Me.label1.Text = "Indicated Air Speed.  (Basic Integer Read)"
        '
        'btnStart
        '
        Me.btnStart.Location = New System.Drawing.Point(206, 12)
        Me.btnStart.Name = "btnStart"
        Me.btnStart.Size = New System.Drawing.Size(191, 24)
        Me.btnStart.TabIndex = 34
        Me.btnStart.Text = "Connect to FSUIPC"
        Me.btnStart.UseVisualStyleBackColor = True
        '
        'txtCOM2
        '
        Me.txtCOM2.Location = New System.Drawing.Point(206, 131)
        Me.txtCOM2.Name = "txtCOM2"
        Me.txtCOM2.ReadOnly = True
        Me.txtCOM2.Size = New System.Drawing.Size(77, 20)
        Me.txtCOM2.TabIndex = 37
        '
        'label8
        '
        Me.label8.Location = New System.Drawing.Point(6, 131)
        Me.label8.Name = "label8"
        Me.label8.Size = New System.Drawing.Size(194, 33)
        Me.label8.TabIndex = 36
        Me.label8.Text = "COM2 (Example of decoding a BCD frequency)"
        '
        'TabControl1
        '
        Me.TabControl1.Controls.Add(Me.TabPage1)
        Me.TabControl1.Controls.Add(Me.TabPage2)
        Me.TabControl1.Controls.Add(Me.TabPage3)
        Me.TabControl1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.TabControl1.Location = New System.Drawing.Point(0, 0)
        Me.TabControl1.Name = "TabControl1"
        Me.TabControl1.SelectedIndex = 0
        Me.TabControl1.Size = New System.Drawing.Size(469, 562)
        Me.TabControl1.TabIndex = 38
        '
        'TabPage1
        '
        Me.TabPage1.Controls.Add(Me.label1)
        Me.TabPage1.Controls.Add(Me.txtCOM2)
        Me.TabPage1.Controls.Add(Me.label7)
        Me.TabPage1.Controls.Add(Me.label8)
        Me.TabPage1.Controls.Add(Me.label3)
        Me.TabPage1.Controls.Add(Me.btnStart)
        Me.TabPage1.Controls.Add(Me.label2)
        Me.TabPage1.Controls.Add(Me.chkPause)
        Me.TabPage1.Controls.Add(Me.label4)
        Me.TabPage1.Controls.Add(Me.label6)
        Me.TabPage1.Controls.Add(Me.txtIAS)
        Me.TabPage1.Controls.Add(Me.label5)
        Me.TabPage1.Controls.Add(Me.txtCompass)
        Me.TabPage1.Controls.Add(Me.chkCabin)
        Me.TabPage1.Controls.Add(Me.txtFSDateTime)
        Me.TabPage1.Controls.Add(Me.chkLogo)
        Me.TabPage1.Controls.Add(Me.txtAircraftType)
        Me.TabPage1.Controls.Add(Me.chkWing)
        Me.TabPage1.Controls.Add(Me.btnGetAircraftType)
        Me.TabPage1.Controls.Add(Me.chkRecognition)
        Me.TabPage1.Controls.Add(Me.btnDisconnect)
        Me.TabPage1.Controls.Add(Me.chkTaxi)
        Me.TabPage1.Controls.Add(Me.btnDisconnectAfterNext)
        Me.TabPage1.Controls.Add(Me.chkInstuments)
        Me.TabPage1.Controls.Add(Me.btnReconnect)
        Me.TabPage1.Controls.Add(Me.chkLanding)
        Me.TabPage1.Controls.Add(Me.btnReconnectOnce)
        Me.TabPage1.Controls.Add(Me.chkStrobes)
        Me.TabPage1.Controls.Add(Me.chkNavigation)
        Me.TabPage1.Controls.Add(Me.chkBeacon)
        Me.TabPage1.Controls.Add(Me.chkAvionics)
        Me.TabPage1.Location = New System.Drawing.Point(4, 22)
        Me.TabPage1.Name = "TabPage1"
        Me.TabPage1.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage1.Size = New System.Drawing.Size(461, 536)
        Me.TabPage1.TabIndex = 0
        Me.TabPage1.Text = "Basics"
        Me.TabPage1.UseVisualStyleBackColor = True
        '
        'TabPage2
        '
        Me.TabPage2.Controls.Add(Me.Label10)
        Me.TabPage2.Controls.Add(Me.btnMoveToEGLL)
        Me.TabPage2.Controls.Add(Me.chkPlaneOnRunway)
        Me.TabPage2.Controls.Add(Me.txtBearing)
        Me.TabPage2.Controls.Add(Me.cbxDistanceUnits)
        Me.TabPage2.Controls.Add(Me.txtDistance)
        Me.TabPage2.Controls.Add(Me.label18)
        Me.TabPage2.Controls.Add(Me.txtLongitude)
        Me.TabPage2.Controls.Add(Me.txtLatitude)
        Me.TabPage2.Controls.Add(Me.label17)
        Me.TabPage2.Location = New System.Drawing.Point(4, 22)
        Me.TabPage2.Name = "TabPage2"
        Me.TabPage2.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPage2.Size = New System.Drawing.Size(461, 536)
        Me.TabPage2.TabIndex = 1
        Me.TabPage2.Text = "Longitude/Latitude"
        Me.TabPage2.UseVisualStyleBackColor = True
        '
        'btnMoveToEGLL
        '
        Me.btnMoveToEGLL.Location = New System.Drawing.Point(16, 259)
        Me.btnMoveToEGLL.Name = "btnMoveToEGLL"
        Me.btnMoveToEGLL.Size = New System.Drawing.Size(123, 23)
        Me.btnMoveToEGLL.TabIndex = 16
        Me.btnMoveToEGLL.Text = "Move to EGLL 27L"
        Me.btnMoveToEGLL.UseVisualStyleBackColor = True
        '
        'chkPlaneOnRunway
        '
        Me.chkPlaneOnRunway.CheckAlign = System.Drawing.ContentAlignment.TopLeft
        Me.chkPlaneOnRunway.Location = New System.Drawing.Point(16, 189)
        Me.chkPlaneOnRunway.Name = "chkPlaneOnRunway"
        Me.chkPlaneOnRunway.Size = New System.Drawing.Size(382, 51)
        Me.chkPlaneOnRunway.TabIndex = 15
        Me.chkPlaneOnRunway.Text = "Is plane on runway 27L (09R) at EGLL?   (Example of using the FsLatLonQuadrange c" & _
            "lass to determine if the current position is within the bound of the quadrangle " & _
            "- in this case the runway)."
        Me.chkPlaneOnRunway.TextAlign = System.Drawing.ContentAlignment.TopLeft
        Me.chkPlaneOnRunway.UseVisualStyleBackColor = True
        '
        'txtBearing
        '
        Me.txtBearing.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtBearing.Location = New System.Drawing.Point(311, 135)
        Me.txtBearing.Name = "txtBearing"
        Me.txtBearing.Size = New System.Drawing.Size(84, 20)
        Me.txtBearing.TabIndex = 14
        '
        'cbxDistanceUnits
        '
        Me.cbxDistanceUnits.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cbxDistanceUnits.FormattingEnabled = True
        Me.cbxDistanceUnits.Items.AddRange(New Object() {"Nautical Miles", "Statute Miles", "Kilometres"})
        Me.cbxDistanceUnits.Location = New System.Drawing.Point(146, 134)
        Me.cbxDistanceUnits.Name = "cbxDistanceUnits"
        Me.cbxDistanceUnits.Size = New System.Drawing.Size(146, 21)
        Me.cbxDistanceUnits.TabIndex = 13
        '
        'txtDistance
        '
        Me.txtDistance.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtDistance.Location = New System.Drawing.Point(16, 135)
        Me.txtDistance.Name = "txtDistance"
        Me.txtDistance.Size = New System.Drawing.Size(124, 20)
        Me.txtDistance.TabIndex = 12
        '
        'label18
        '
        Me.label18.Location = New System.Drawing.Point(13, 81)
        Me.label18.Name = "label18"
        Me.label18.Size = New System.Drawing.Size(319, 51)
        Me.label18.TabIndex = 11
        Me.label18.Text = "Distance and Magnetic Bearing to London Heathrow (EGLL).  (Example of using the f" & _
            "sLatLonPoint class to calculate distance and bearing between two points)."
        '
        'txtLongitude
        '
        Me.txtLongitude.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtLongitude.Location = New System.Drawing.Point(211, 37)
        Me.txtLongitude.Name = "txtLongitude"
        Me.txtLongitude.Size = New System.Drawing.Size(188, 20)
        Me.txtLongitude.TabIndex = 10
        '
        'txtLatitude
        '
        Me.txtLatitude.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtLatitude.Location = New System.Drawing.Point(17, 37)
        Me.txtLatitude.Name = "txtLatitude"
        Me.txtLatitude.Size = New System.Drawing.Size(188, 20)
        Me.txtLatitude.TabIndex = 9
        '
        'label17
        '
        Me.label17.AutoSize = True
        Me.label17.Location = New System.Drawing.Point(14, 16)
        Me.label17.Name = "label17"
        Me.label17.Size = New System.Drawing.Size(319, 13)
        Me.label17.TabIndex = 8
        Me.label17.Text = "Current position.  (Example of FsLongitude and FsLatitude classes)"
        '
        'TabPage3
        '
        Me.TabPage3.Controls.Add(Me.pnlAIRadar)
        Me.TabPage3.Controls.Add(Me.Label9)
        Me.TabPage3.Controls.Add(Me.chkShowGroundAI)
        Me.TabPage3.Controls.Add(Me.chkShowAirborneAI)
        Me.TabPage3.Controls.Add(Me.cbxRadarRange)
        Me.TabPage3.Controls.Add(Me.chkEnableAIRadar)
        Me.TabPage3.Location = New System.Drawing.Point(4, 22)
        Me.TabPage3.Name = "TabPage3"
        Me.TabPage3.Size = New System.Drawing.Size(461, 536)
        Me.TabPage3.TabIndex = 2
        Me.TabPage3.Text = "AI Traffic Radar"
        Me.TabPage3.UseVisualStyleBackColor = True
        '
        'Label9
        '
        Me.Label9.AutoSize = True
        Me.Label9.Location = New System.Drawing.Point(6, 47)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(114, 13)
        Me.Label9.TabIndex = 20
        Me.Label9.Text = "Range (Nautical Miles)"
        '
        'chkShowGroundAI
        '
        Me.chkShowGroundAI.AutoSize = True
        Me.chkShowGroundAI.Location = New System.Drawing.Point(344, 46)
        Me.chkShowGroundAI.Name = "chkShowGroundAI"
        Me.chkShowGroundAI.Size = New System.Drawing.Size(104, 17)
        Me.chkShowGroundAI.TabIndex = 19
        Me.chkShowGroundAI.Text = "Show Ground AI"
        Me.chkShowGroundAI.UseVisualStyleBackColor = True
        '
        'chkShowAirborneAI
        '
        Me.chkShowAirborneAI.AutoSize = True
        Me.chkShowAirborneAI.Checked = True
        Me.chkShowAirborneAI.CheckState = System.Windows.Forms.CheckState.Checked
        Me.chkShowAirborneAI.Location = New System.Drawing.Point(220, 46)
        Me.chkShowAirborneAI.Name = "chkShowAirborneAI"
        Me.chkShowAirborneAI.Size = New System.Drawing.Size(108, 17)
        Me.chkShowAirborneAI.TabIndex = 18
        Me.chkShowAirborneAI.Text = "Show Airborne AI"
        Me.chkShowAirborneAI.UseVisualStyleBackColor = True
        '
        'cbxRadarRange
        '
        Me.cbxRadarRange.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cbxRadarRange.FormattingEnabled = True
        Me.cbxRadarRange.Items.AddRange(New Object() {"50", "40", "30", "20", "10", "5", "1"})
        Me.cbxRadarRange.Location = New System.Drawing.Point(133, 44)
        Me.cbxRadarRange.Name = "cbxRadarRange"
        Me.cbxRadarRange.Size = New System.Drawing.Size(65, 21)
        Me.cbxRadarRange.TabIndex = 17
        '
        'chkEnableAIRadar
        '
        Me.chkEnableAIRadar.CheckAlign = System.Drawing.ContentAlignment.TopLeft
        Me.chkEnableAIRadar.Enabled = False
        Me.chkEnableAIRadar.Location = New System.Drawing.Point(8, 14)
        Me.chkEnableAIRadar.Name = "chkEnableAIRadar"
        Me.chkEnableAIRadar.Size = New System.Drawing.Size(440, 24)
        Me.chkEnableAIRadar.TabIndex = 16
        Me.chkEnableAIRadar.Text = "Turn on AI Radar.  (Example of using the AITrafficServices to render a simple AI " & _
            "Radar)."
        Me.chkEnableAIRadar.TextAlign = System.Drawing.ContentAlignment.TopLeft
        Me.chkEnableAIRadar.UseVisualStyleBackColor = True
        '
        'AIRadarTimer
        '
        Me.AIRadarTimer.Interval = 1000
        '
        'Label10
        '
        Me.Label10.Location = New System.Drawing.Point(147, 259)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(252, 68)
        Me.Label10.TabIndex = 17
        Me.Label10.Text = "Move the plane to the start of Runway 27L at London Heathrow (EGLL).  " & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "(Example " & _
            "of writing longitudes and latitudes and performing simple maths with them)."
        '
        'pnlAIRadar
        '
        Me.pnlAIRadar.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.pnlAIRadar.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.pnlAIRadar.Location = New System.Drawing.Point(11, 86)
        Me.pnlAIRadar.Name = "pnlAIRadar"
        Me.pnlAIRadar.Size = New System.Drawing.Size(440, 440)
        Me.pnlAIRadar.TabIndex = 21
        '
        'Form1
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(469, 562)
        Me.Controls.Add(Me.TabControl1)
        Me.Name = "Form1"
        Me.Text = "FSUIPCClientExample_VB"
        Me.TabControl1.ResumeLayout(False)
        Me.TabPage1.ResumeLayout(False)
        Me.TabPage1.PerformLayout()
        Me.TabPage2.ResumeLayout(False)
        Me.TabPage2.PerformLayout()
        Me.TabPage3.ResumeLayout(False)
        Me.TabPage3.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents Timer1 As System.Windows.Forms.Timer
    Private WithEvents chkPause As System.Windows.Forms.CheckBox
    Private WithEvents label6 As System.Windows.Forms.Label
    Private WithEvents label5 As System.Windows.Forms.Label
    Private WithEvents chkCabin As System.Windows.Forms.CheckBox
    Private WithEvents chkLogo As System.Windows.Forms.CheckBox
    Private WithEvents chkWing As System.Windows.Forms.CheckBox
    Private WithEvents chkRecognition As System.Windows.Forms.CheckBox
    Private WithEvents chkTaxi As System.Windows.Forms.CheckBox
    Private WithEvents chkInstuments As System.Windows.Forms.CheckBox
    Private WithEvents chkLanding As System.Windows.Forms.CheckBox
    Private WithEvents chkStrobes As System.Windows.Forms.CheckBox
    Private WithEvents chkBeacon As System.Windows.Forms.CheckBox
    Private WithEvents chkAvionics As System.Windows.Forms.CheckBox
    Private WithEvents chkNavigation As System.Windows.Forms.CheckBox
    Private WithEvents btnReconnectOnce As System.Windows.Forms.Button
    Private WithEvents btnReconnect As System.Windows.Forms.Button
    Private WithEvents btnDisconnectAfterNext As System.Windows.Forms.Button
    Private WithEvents btnDisconnect As System.Windows.Forms.Button
    Private WithEvents btnGetAircraftType As System.Windows.Forms.Button
    Private WithEvents txtAircraftType As System.Windows.Forms.TextBox
    Private WithEvents txtFSDateTime As System.Windows.Forms.TextBox
    Private WithEvents txtCompass As System.Windows.Forms.TextBox
    Private WithEvents txtIAS As System.Windows.Forms.TextBox
    Private WithEvents label4 As System.Windows.Forms.Label
    Private WithEvents label2 As System.Windows.Forms.Label
    Private WithEvents label3 As System.Windows.Forms.Label
    Private WithEvents label7 As System.Windows.Forms.Label
    Private WithEvents label1 As System.Windows.Forms.Label
    Private WithEvents btnStart As System.Windows.Forms.Button
    Private WithEvents txtCOM2 As System.Windows.Forms.TextBox
    Private WithEvents label8 As System.Windows.Forms.Label
    Friend WithEvents TabControl1 As System.Windows.Forms.TabControl
    Friend WithEvents TabPage1 As System.Windows.Forms.TabPage
    Friend WithEvents TabPage2 As System.Windows.Forms.TabPage
    Friend WithEvents AIRadarTimer As System.Windows.Forms.Timer
    Friend WithEvents TabPage3 As System.Windows.Forms.TabPage
    Private WithEvents chkPlaneOnRunway As System.Windows.Forms.CheckBox
    Private WithEvents txtBearing As System.Windows.Forms.TextBox
    Private WithEvents cbxDistanceUnits As System.Windows.Forms.ComboBox
    Private WithEvents txtDistance As System.Windows.Forms.TextBox
    Private WithEvents label18 As System.Windows.Forms.Label
    Private WithEvents txtLongitude As System.Windows.Forms.TextBox
    Private WithEvents txtLatitude As System.Windows.Forms.TextBox
    Private WithEvents label17 As System.Windows.Forms.Label
    Friend WithEvents pnlAIRadar As DoubleBufferPanel
    Private WithEvents Label9 As System.Windows.Forms.Label
    Private WithEvents chkShowGroundAI As System.Windows.Forms.CheckBox
    Private WithEvents chkShowAirborneAI As System.Windows.Forms.CheckBox
    Private WithEvents cbxRadarRange As System.Windows.Forms.ComboBox
    Private WithEvents chkEnableAIRadar As System.Windows.Forms.CheckBox
    Private WithEvents btnMoveToEGLL As System.Windows.Forms.Button
    Private WithEvents Label10 As System.Windows.Forms.Label

End Class
