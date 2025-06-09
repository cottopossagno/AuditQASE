Imports System.Data.SqlClient

Public Class ElencoAudit

    Private ReadOnly connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("VMSQL_AuditQASE").ConnectionString

#Region " Definizione Proprietà di classe"
    Public Property ID As Integer
    Public Property StabilimentoAudit As String = ""
    Public Property Anno As Integer
    Public Property Reparto As String = ""
    Public Property AuditData As Date?
    Public Property NumeroAudit As String = ""
    Public Property EsitoAudit As String = ""
    Public Property AuditEffettuato As Integer
    Public Property AuditScaduto As String = ""
    Public Property RifAC As String = ""
    Public Property RapportoAudit As String = ""


#End Region

#Region "Metodo classe"
    Public Function ListaElencoAudit(StabilimentoAudit As String) As List(Of ElencoAudit)
        Dim con As New SqlConnection(connectionString)
        Dim cmd As New SqlCommand("", con)
        Dim dr As SqlDataReader
        Dim sql As String = ""
        Dim ret As New List(Of ElencoAudit)

        Try
            con.ConnectionString = connectionString
            con.Open()

            sql = "SELECT * FROM viewElencoAudit Where 1=1"

            If StabilimentoAudit <> "" Then
                sql = sql + " and StabilimentoAudit like '" + StabilimentoAudit + "'"
            End If

            sql = sql + " order by Anno Desc,StabilimentoAudit, NumeroAudit"



            cmd.CommandText = sql
            dr = cmd.ExecuteReader()
            Do While dr.Read()
                ' Compila classe Documento per il record corrente
                Dim tmpElencoAudit As New ElencoAudit

                tmpElencoAudit.ID = dr.GetValue(dr.GetOrdinal("ID"))
                If Not dr.IsDBNull(dr.GetOrdinal("StabilimentoAudit")) Then tmpElencoAudit.StabilimentoAudit = dr.GetString(dr.GetOrdinal("StabilimentoAudit")).Trim
                If Not dr.IsDBNull(dr.GetOrdinal("Anno")) Then tmpElencoAudit.Anno = dr.GetValue(dr.GetOrdinal("Anno"))
                If Not dr.IsDBNull(dr.GetOrdinal("AuditData")) Then tmpElencoAudit.AuditData = dr.GetValue(dr.GetOrdinal("AuditData"))
                If Not dr.IsDBNull(dr.GetOrdinal("Reparto")) Then tmpElencoAudit.Reparto = dr.GetString(dr.GetOrdinal("Reparto")).Trim
                If Not dr.IsDBNull(dr.GetOrdinal("NumeroAudit")) Then tmpElencoAudit.NumeroAudit = dr.GetString(dr.GetOrdinal("NumeroAudit")).Trim
                If Not dr.IsDBNull(dr.GetOrdinal("EsitoAudit")) Then tmpElencoAudit.EsitoAudit = dr.GetString(dr.GetOrdinal("EsitoAudit")).Trim
                If Not dr.IsDBNull(dr.GetOrdinal("AuditEffettuato")) Then tmpElencoAudit.AuditEffettuato = dr.GetValue(dr.GetOrdinal("AuditEffettuato"))
                If Not dr.IsDBNull(dr.GetOrdinal("AuditScaduto")) Then tmpElencoAudit.AuditScaduto = dr.GetValue(dr.GetOrdinal("AuditScaduto"))
                If Not dr.IsDBNull(dr.GetOrdinal("RifAC")) Then tmpElencoAudit.RifAC = dr.GetString(dr.GetOrdinal("RifAC")).Trim
                If Not dr.IsDBNull(dr.GetOrdinal("RapportoAudit")) Then tmpElencoAudit.RapportoAudit = dr.GetString(dr.GetOrdinal("RapportoAudit")).Trim

                ret.Add(tmpElencoAudit)
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
