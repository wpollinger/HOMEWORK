Attribute VB_Name = "Module1"
Sub run()
Worksheets("2016").Activate
Call Module2.sheet1

Worksheets("2015").Activate
Call Module2.sheet2

Worksheets("2014").Activate
Call Module2.sheet3

Worksheets("Main").Activate
Range("B2").Value = "COMPLETED"
Range("B3").Value = "COMPLETED"
Range("B4").Value = "COMPLETED"
End Sub

Sub clearall()
Worksheets("Main").Activate
Range("B2:B100").Clear
Worksheets("2016").Activate
Call Button2_Click
Worksheets("2015").Activate
Call Button2_Click
Worksheets("2014").Activate
Worksheets("Main").Activate
End Sub




