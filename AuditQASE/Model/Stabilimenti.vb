Imports System.Data.SqlClient

Public Class Stabilimenti

    Private ReadOnly connectionString As String = System.Configuration.ConfigurationManager.ConnectionStrings("VMSQL_AuditQASE").ConnectionString

#Region " Definizione Proprietà di classe"
    Public Property Stabilimenti As String = ""

#End Region


#Region "Metodo classe"
    Public Function ListaStabilimenti() As List(Of Stabilimenti)
        Dim con As New SqlConnection(connectionString)
        Dim cmd As New SqlCommand("", con)
        Dim dr As SqlDataReader
        Dim sql As String = ""
        Dim ret As New List(Of Stabilimenti)

        Try
            con.ConnectionString = connectionString
            con.Open()

            sql = "SELECT NomeStabilimento FROM tblNomiStabilimenti order by NomeStabilimento"

            cmd.CommandText = sql
            dr = cmd.ExecuteReader()
            Do While dr.Read()
                ' Compila classe Documento per il record corrente
                Dim tmpNomiStabilimenti As New Stabilimenti

                If Not dr.IsDBNull(dr.GetOrdinal("NomeStabilimento")) Then tmpNomiStabilimenti.Stabilimenti = dr.GetString(dr.GetOrdinal("NomeStabilimento")).Trim

                ret.Add(tmpNomiStabilimenti)
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
