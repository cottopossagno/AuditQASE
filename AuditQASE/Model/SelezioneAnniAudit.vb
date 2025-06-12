Imports System.Data.SqlClient
Public Class SelezioneAnniAudit

    Private ReadOnly connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("VMSQL_AuditQASE").ConnectionString

#Region " Definizione Proprietà di classe"
    Public Property AnnoAudit As String = ""

#End Region

#Region "Metodo classe"
    Public Function ListaAnniAudit() As List(Of SelezioneAnniAudit)
        Dim con As New SqlConnection(connectionString)
        Dim cmd As New SqlCommand("", con)
        Dim dr As SqlDataReader
        Dim sql As String = ""
        Dim ret As New List(Of SelezioneAnniAudit)

        Try
            con.ConnectionString = connectionString
            con.Open()

            sql = "SELECT AnnoAudit FROM viewSelezioneAnnoAudit order by AnnoAudit desc"

            cmd.CommandText = sql
            dr = cmd.ExecuteReader()
            Do While dr.Read()
                ' Compila classe Documento per il record corrente
                Dim tmpAnnoAudit As New SelezioneAnniAudit

                If Not dr.IsDBNull(dr.GetOrdinal("AnnoAudit")) Then tmpAnnoAudit.AnnoAudit = dr.GetValue(dr.GetOrdinal("AnnoAudit"))

                ret.Add(tmpAnnoAudit)
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
