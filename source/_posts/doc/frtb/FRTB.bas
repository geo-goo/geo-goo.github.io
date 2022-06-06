Attribute VB_Name = "FRTB"
Sub Main()
    Dim T As Double
    T = CalCorrelation(0.25, 0.5, 1)
    MsgBox T
End Sub

Function CalRhoLowAndGammaLow(Rho As Double) As Double
    CalRhoLowAndGammaLow = WorksheetFunction.Max(2 * Rho - 1, 0.75 * Rho)
End Function


Function CalHighMedianLowCorrelation(Correlation As Double, Rank As Double)
    If Rank = 0.75 Then
        CalHighMedianLowCorrelation = CalRhoLowAndGammaLow(Correlation)
    ElseIf Rank = 1.25 Then
        CalHighMedianLowCorrelation = 1.25 * Correlation
    Else
        CalHighMedianLowCorrelation = Correlation
    End If
End Function

'girr
Function CalGIRRCorrelation(T1 As Double, T2 As Double, Rank As Double) As Double
    CalGIRRCorrelation = WorksheetFunction.Max(Exp(-0.03 * Abs(T1 - T2) / WorksheetFunction.Min(T1, T2)), 0.4)
    CalGIRRCorrelation = CalHighMedianLowCorrelation(CalGIRRCorrelation, Rank)
End Function

'formula
Function CalKb(T1 As Double, T2 As Double, Wk1 As Double, Wk2 As Double, Rho As Double) As Double
    If T1 = T2 Then
        CalKb = Wk1 * Wk1
    Else
        CalKb = Wk1 * Wk2 * Rho
    End If
End Function

Function CalKbResult(Arr As Range)
    CalKbResult = Math.Sqr(WorksheetFunction.Max(0, Arr))
End Function

'formula for vega
Function CalVegaKb(T11 As Double, T21 As Double, T12 As Double, T22 As Double, Wk1 As Double, Wk2 As Double, Rho As Double) As Double
    If T11 = T21 And T12 = T22 Then
        CalVegaKb = Wk1 * Wk1
    Else
        CalVegaKb = Wk1 * Wk2 * Rho
    End If
End Function

'vega
Function CalVegaRiskWeighted(LHRiskClass As Double) As Double
    CalVegaRiskWeighted = WorksheetFunction.Min(0.55 * Math.Sqr(LHRiskClass / 10), 1)
End Function

Function CalVegaCorrelation(IsGIRR As Boolean, T1 As Double, T2 As Double, T1New As Double, T2New As Double, Rank As Double) As Double
    Dim Rho_OptionMaturity As Double
    Rho_OptionMaturity = Exp(-0.01 * Abs(T1 - T2) / WorksheetFunction.Min(T1, T2))
    Dim Rho As Double
    If IsGIRR Then
        Rho = Exp(-0.01 * Abs(T1New - T2New) / WorksheetFunction.Min(T1New, T2New))
    Else
        Rho = T1New
    End If
    CalVegaCorrelation = WorksheetFunction.Min(Rho * Rho_OptionMaturity, 1)
    CalVegaCorrelation = CalHighMedianLowCorrelation(CalVegaCorrelation, Rank)
End Function

Function CalCurvaturePhi(Cvr1 As Double, Cvr2 As Double) As Integer
    If Cvr1 < 0 And Cvr2 < 0 Then
        CalCurvaturePhi = 0
    Else
        CalCurvaturePhi = 1
    End If
End Function

Function CalCurvatureKb(T1 As String, T2 As String, Cvr1 As Double, Cvr2 As Double, Rho As Double) As Double
    If T1 = T2 Then
        CalCurvatureKb = WorksheetFunction.Max(Cvr1, 0) ^ 2
    Else
        CalCurvatureKb = Rho * Cvr1 * Cvr2 * CalCurvaturePhi(Cvr1, Cvr2)
    End If
End Function

Function CalCurvatureKbResult(Arr1 As Range, Arr2 As Range)
    CalCurvatureKbResult = WorksheetFunction.Max(Math.Sqr(WorksheetFunction.Max(0, Arr1)), Math.Sqr(WorksheetFunction.Max(0, Arr2)))
End Function

'csr
Function CalCSRRiskWeightedNonSec(RiskBucket As Integer) As Double
    If RiskBucket = 1 Then
        CalCSRRiskWeightedNonSec = 0.005
    ElseIf (RiskBucket = 2) Then
        CalCSRRiskWeightedNonSec = 0.01
    ElseIf (RiskBucket = 3) Then
        CalCSRRiskWeightedNonSec = 0.05
    ElseIf (RiskBucket = 4) Then
        CalCSRRiskWeightedNonSec = 0.03
    ElseIf (RiskBucket = 5) Then
        CalCSRRiskWeightedNonSec = 0.03
    ElseIf (RiskBucket = 6) Then
        CalCSRRiskWeightedNonSec = 0.02
    ElseIf (RiskBucket = 7) Then
        CalCSRRiskWeightedNonSec = 0.015
    ElseIf (RiskBucket = 8) Then
        CalCSRRiskWeightedNonSec = 0.025
    ElseIf (RiskBucket = 9) Then
        CalCSRRiskWeightedNonSec = 0.02
    ElseIf (RiskBucket = 10) Then
        CalCSRRiskWeightedNonSec = 0.04
    ElseIf (RiskBucket = 11) Then
        CalCSRRiskWeightedNonSec = 0.12
    ElseIf (RiskBucket = 12) Then
        CalCSRRiskWeightedNonSec = 0.07
    ElseIf (RiskBucket = 13) Then
        CalCSRRiskWeightedNonSec = 0.085
    ElseIf (RiskBucket = 14) Then
        CalCSRRiskWeightedNonSec = 0.055
    ElseIf (RiskBucket = 15) Then
        CalCSRRiskWeightedNonSec = 0.05
    ElseIf (RiskBucket = 16) Then
        CalCSRRiskWeightedNonSec = 0.12
    ElseIf (RiskBucket = 17) Then
        CalCSRRiskWeightedNonSec = 0.015
    ElseIf (RiskBucket = 18) Then
        CalCSRRiskWeightedNonSec = 0.05
    End If
End Function

Function CalCSRCurvatureCorrelationNonSec(RiskBucket As Integer, IsIdenticalName As Boolean, Rank As Double) As Double
    If RiskBucket <= 15 Then
        If IsIdenticalName Then
            CalCSRCurvatureCorrelationNonSec = 1
        Else
            CalCSRCurvatureCorrelationNonSec = 0.35 * 0.35
        End If
    ElseIf (RiskBucket = 16) Then
        CalCSRCurvatureCorrelationNonSec = 0
    Else
        If IsIdenticalName Then
            CalCSRCurvatureCorrelationNonSec = 1
        Else
            CalCSRCurvatureCorrelationNonSec = 0.8 * 0.8
        End If
    End If
    CalCSRCurvatureCorrelationNonSec = CalHighMedianLowCorrelation(CalCSRCurvatureCorrelationNonSec, Rank)
End Function

Function CalCSRRiskWeightedCTP(RiskBucket As Integer) As Double
    If RiskBucket = 1 Then
        CalCSRRiskWeightedCTP = 0.04
    ElseIf (RiskBucket = 2) Then
        CalCSRRiskWeightedCTP = 0.04
    ElseIf (RiskBucket = 3) Then
        CalCSRRiskWeightedCTP = 0.08
    ElseIf (RiskBucket = 4) Then
        CalCSRRiskWeightedCTP = 0.05
    ElseIf (RiskBucket = 5) Then
        CalCSRRiskWeightedCTP = 0.04
    ElseIf (RiskBucket = 6) Then
        CalCSRRiskWeightedCTP = 0.03
    ElseIf (RiskBucket = 7) Then
        CalCSRRiskWeightedCTP = 0.02
    ElseIf (RiskBucket = 8) Then
        CalCSRRiskWeightedCTP = 0.06
    ElseIf (RiskBucket = 9) Then
        CalCSRRiskWeightedCTP = 0.13
    ElseIf (RiskBucket = 10) Then
        CalCSRRiskWeightedCTP = 0.13
    ElseIf (RiskBucket = 11) Then
        CalCSRRiskWeightedCTP = 0.16
    ElseIf (RiskBucket = 12) Then
        CalCSRRiskWeightedCTP = 0.1
    ElseIf (RiskBucket = 13) Then
        CalCSRRiskWeightedCTP = 0.12
    ElseIf (RiskBucket = 14) Then
        CalCSRRiskWeightedCTP = 0.12
    ElseIf (RiskBucket = 15) Then
        CalCSRRiskWeightedCTP = 0.12
    ElseIf (RiskBucket = 16) Then
        CalCSRRiskWeightedCTP = 0.13
    End If
End Function

Function CalCSRCurvatureCorrelationCTP(RiskBucket As Integer, IsIdenticalName As Boolean, Rank As Double) As Double
    If RiskBucket <= 15 Then
        If IsIdenticalName Then
            CalCSRCurvatureCorrelationCTP = 1
        Else
            CalCSRCurvatureCorrelationCTP = 0.35 * 0.35
        End If
    Else
        CalCSRCurvatureCorrelationCTP = 0
    End If
    CalCSRCurvatureCorrelationCTP = CalHighMedianLowCorrelation(CalCSRCurvatureCorrelationCTP, Rank)
End Function


Function CalCSRRiskWeightedNonCTPOneUntilEight(RiskBucket As Integer) As Double
    If RiskBucket = 1 Then
        CalCSRRiskWeightedNonCTPOneUntilEight = 0.009
    ElseIf (RiskBucket = 2) Then
        CalCSRRiskWeightedNonCTPOneUntilEight = 0.015
    ElseIf (RiskBucket = 3) Then
        CalCSRRiskWeightedNonCTPOneUntilEight = 0.02
    ElseIf (RiskBucket = 4) Then
        CalCSRRiskWeightedNonCTPOneUntilEight = 0.02
    ElseIf (RiskBucket = 5) Then
        CalCSRRiskWeightedNonCTPOneUntilEight = 0.008
    ElseIf (RiskBucket = 6) Then
        CalCSRRiskWeightedNonCTPOneUntilEight = 0.012
    ElseIf (RiskBucket = 7) Then
        CalCSRRiskWeightedNonCTPOneUntilEight = 0.012
    ElseIf (RiskBucket = 8) Then
        CalCSRRiskWeightedNonCTPOneUntilEight = 0.014
    End If
End Function

Function CalCSRRiskWeightedNonCTP(RiskBucket As Integer) As Double
    Dim number#
    If RiskBucket = 25 Then
        number = 0.035 / 0.009
    ElseIf RiskBucket >= 17 Then
        number = 1.75
    ElseIf RiskBucket >= 9 Then
        number = 1.25
    Else
        number = 1
    End If
    CalCSRRiskWeightedNonCTP = CalCSRRiskWeightedNonCTPOneUntilEight(RiskBucket Mod 8) * number
End Function

Function CalCSRCorrelationNonSec(RiskBucket As Integer, IsIdenticalName As Boolean, IsIdenticalTenor As Boolean, IsIdenticalBasis As Boolean, Rank As Double) As Double
    Dim rhoName As Double
    Dim rhoTenor As Double
    Dim rhoBasis As Double
    If IsIdenticalTenor Then
        rhoTenor = 1
    ElseIf IsIdenticalTenor = False Then
        rhoTenor = 0.65
    End If
    If IsIdenticalBasis Then
        rhoBasis = 1
    ElseIf IsIdenticalBasis = False Then
        rhoBasis = 0.999
    End If
    If RiskBucket <= 15 Then
        If IsIdenticalName Then
            rhoName = 1
        Else
            rhoName = 0.35
        End If
    ElseIf RiskBucket = 16 Then
        rhoName = 0
        rhoTenor = 0
        rhoBasis = 0
    Else
        If IsIdenticalName Then
            rhoName = 1
        Else
            rhoName = 0.8
        End If
    End If
    CalCSRCorrelationNonSec = rhoName * rhoTenor * rhoBasis
    CalCSRCorrelationNonSec = CalHighMedianLowCorrelation(CalCSRCorrelationNonSec, Rank)
End Function

Function CalCSRCorrelationCTP(RiskBucket As Integer, IsIdenticalName As Boolean, IsIdenticalTenor As Boolean, IsIdenticalBasis As Boolean, Rank As Double) As Double
    Dim rhoName As Double
    Dim rhoTenor As Double
    Dim rhoBasis As Double
    
    If IsIdenticalTenor Then
        rhoTenor = 1
    ElseIf IsIdenticalTenor = False Then
        rhoTenor = 0.65
    End If
    
    If IsIdenticalBasis Then
        rhoBasis = 1
    ElseIf IsIdenticalBasis = False Then
        rhoBasis = 0.99
    End If
    
    If IsIdenticalName Then
        rhoName = 1
    Else
        rhoName = 0.35
    End If
    
    If RiskBucket = 16 Then
        rhoName = 0
        rhoTenor = 0
        rhoBasis = 0
    End If
    CalCSRCorrelationCTP = rhoName * rhoTenor * rhoBasis
    CalCSRCorrelationCTP = CalHighMedianLowCorrelation(CalCSRCorrelationCTP, Rank)
End Function

'tools
Function TakeRange(Arr As Range, str As String) As Double
     TakeRange = Range(str).Value
End Function

