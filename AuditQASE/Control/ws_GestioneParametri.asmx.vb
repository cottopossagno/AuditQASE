Imports System.ComponentModel
Imports System.Web.Script.Services
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports Newtonsoft.Json

' Per consentire la chiamata di questo servizio Web dallo script utilizzando ASP.NET AJAX, rimuovere il commento dalla riga seguente.
' <System.Web.Script.Services.ScriptService()> _
<System.Web.Services.WebService(Namespace:="http://tempuri.org/")> _
<System.Web.Services.WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<ToolboxItem(False)> _
Public Class ws_GestioneParametri
    Inherits System.Web.Services.WebService

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json, UseHttpGet:=True)>
    Public Sub GetListStabilimenti()
        Dim myNomiStabilimenti As New Stabilimenti()
        Dim jsonElement As New Dictionary(Of String, Object)
        Dim ret As New List(Of Stabilimenti)
        Dim jsonRet As String
        Dim TotRec As Integer = ret.Count

        Try
            ret = myNomiStabilimenti.ListaStabilimenti 'questa funzione proviene dalla classe 

            jsonElement.Add("draw", Context.Request.Params("draw"))
            jsonElement.Add("recordsTotal", ret.Count)
            jsonElement.Add("recordsFiltered", ret.Count)
            jsonElement.Add("data", ret)

            jsonRet = JsonConvert.SerializeObject(jsonElement)

        Catch ex As Exception
            jsonRet = JsonConvert.SerializeObject(ex.Message)

            Context.Response.StatusCode = 500
            Context.Response.StatusDescription = ex.Message
        Finally

            Context.Response.Clear()
            Context.Response.ContentType = "application/json"

            Context.Response.AddHeader("Access-Control-Allow-Origin", "*")

        End Try
        Context.Response.Write(jsonRet)

    End Sub

End Class