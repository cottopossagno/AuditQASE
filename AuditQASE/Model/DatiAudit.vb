Imports System.Data.SqlClient

Public Class DatiAudit

    Private ReadOnly connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("VMSQL_AuditQASE").ConnectionString

#Region " Definizione Proprietà di classe"
    Public Property ID As Integer
    Public Property Reparto As String = ""
    Public Property StabilimentoAudit As String = ""
    Public Property AuditData As Date?
    Public Property NumeroAudit As String = ""
    Public Property Obiettivi As String = ""
    Public Property AuditPianoAnnuale As String = ""
    Public Property LeadAuditor As String = ""
    Public Property AltroAuditor1 As String = ""
    Public Property AltroAuditor2 As String = ""
    Public Property AltroAuditor3 As String = ""
    Public Property Intervistato1 As String = ""
    Public Property Intervistato2 As String = ""
    Public Property Intervistato3 As String = ""
    Public Property ResponsabileArea As String = ""
    Public Property RapportoAudit As String = ""
    Public Property CheckList As String = ""
    Public Property EsitoAudit As String = ""
    Public Property RifAC As String = ""

#End Region


#Region "Metodo classe"
    Public Function ListaDatiAudit() As List(Of DatiAudit)
        Dim con As New SqlConnection(connectionString)
        Dim cmd As New SqlCommand("", con)
        Dim dr As SqlDataReader
        Dim sql As String = ""
        Dim ret As New List(Of DatiAudit)

        Try
            con.ConnectionString = connectionString
            con.Open()

            sql = "SELECT * FROM tblAuditQASE order by AuditData Desc,NumeroAudit Desc"

            cmd.CommandText = sql
            dr = cmd.ExecuteReader()
            Do While dr.Read()
                ' Compila classe Documento per il record corrente
                Dim tmpDatiAudit As New DatiAudit

                tmpDatiAudit.ID = dr.GetValue(dr.GetOrdinal("ID"))
                If Not dr.IsDBNull(dr.GetOrdinal("Reparto")) Then tmpDatiAudit.Reparto = dr.GetString(dr.GetOrdinal("Reparto")).Trim
                If Not dr.IsDBNull(dr.GetOrdinal("StabilimentoAudit")) Then tmpDatiAudit.StabilimentoAudit = dr.GetString(dr.GetOrdinal("StabilimentoAudit")).Trim
                If Not dr.IsDBNull(dr.GetOrdinal("AuditData")) Then tmpDatiAudit.AuditData = dr.GetValue(dr.GetOrdinal("AuditData"))
                If Not dr.IsDBNull(dr.GetOrdinal("NumeroAudit")) Then tmpDatiAudit.NumeroAudit = dr.GetString(dr.GetOrdinal("NumeroAudit")).Trim
                If Not dr.IsDBNull(dr.GetOrdinal("Obiettivi")) Then tmpDatiAudit.Obiettivi = dr.GetString(dr.GetOrdinal("Obiettivi")).Trim
                If Not dr.IsDBNull(dr.GetOrdinal("AuditPianoAnnuale")) Then tmpDatiAudit.AuditPianoAnnuale = dr.GetString(dr.GetOrdinal("AuditPianoAnnuale")).Trim
                If Not dr.IsDBNull(dr.GetOrdinal("LeadAuditor")) Then tmpDatiAudit.LeadAuditor = dr.GetString(dr.GetOrdinal("LeadAuditor")).Trim
                If Not dr.IsDBNull(dr.GetOrdinal("AltroAuditor1")) Then tmpDatiAudit.AltroAuditor1 = dr.GetString(dr.GetOrdinal("AltroAuditor1")).Trim
                If Not dr.IsDBNull(dr.GetOrdinal("AltroAuditor2")) Then tmpDatiAudit.AltroAuditor2 = dr.GetString(dr.GetOrdinal("AltroAuditor2")).Trim
                If Not dr.IsDBNull(dr.GetOrdinal("AltroAuditor3")) Then tmpDatiAudit.AltroAuditor3 = dr.GetString(dr.GetOrdinal("AltroAuditor3")).Trim
                If Not dr.IsDBNull(dr.GetOrdinal("Intervistato1")) Then tmpDatiAudit.Intervistato1 = dr.GetString(dr.GetOrdinal("Intervistato1")).Trim
                If Not dr.IsDBNull(dr.GetOrdinal("Intervistato2")) Then tmpDatiAudit.Intervistato2 = dr.GetString(dr.GetOrdinal("Intervistato2")).Trim
                If Not dr.IsDBNull(dr.GetOrdinal("Intervistato3")) Then tmpDatiAudit.Intervistato3 = dr.GetString(dr.GetOrdinal("Intervistato3")).Trim
                If Not dr.IsDBNull(dr.GetOrdinal("ResponsabileArea")) Then tmpDatiAudit.ResponsabileArea = dr.GetString(dr.GetOrdinal("ResponsabileArea")).Trim
                If Not dr.IsDBNull(dr.GetOrdinal("RapportoAudit")) Then tmpDatiAudit.RapportoAudit = dr.GetString(dr.GetOrdinal("RapportoAudit")).Trim
                If Not dr.IsDBNull(dr.GetOrdinal("CheckList")) Then tmpDatiAudit.CheckList = dr.GetString(dr.GetOrdinal("CheckList")).Trim
                If Not dr.IsDBNull(dr.GetOrdinal("EsitoAudit")) Then tmpDatiAudit.EsitoAudit = dr.GetString(dr.GetOrdinal("EsitoAudit")).Trim
                If Not dr.IsDBNull(dr.GetOrdinal("RifAC")) Then tmpDatiAudit.RifAC = dr.GetString(dr.GetOrdinal("RifAC")).Trim

                ret.Add(tmpDatiAudit)
            Loop
            dr.Close()

        Catch ex As Exception
            Console.WriteLine(ex.Message)
        Finally
            con.Close()
            con.Dispose()
        End Try

        Return ret

    End Function
#End Region
End Class
