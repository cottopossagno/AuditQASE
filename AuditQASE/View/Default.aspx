<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/View/AuditQASE.Master" CodeBehind="Default.aspx.vb" Inherits="AuditQASE._Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script>

        var tblElencoAudit
        var editorDatiAudit

        function loadElencoAudit() {

            $.fn.dataTable.render.moment = function (from, to, locale) {
                // Argument shifting

                if (arguments.length === 1) {
                    locale = 'it'; to = from; from = 'YYYY-MM-DDT00:00:00';
                }
                else if (arguments.length === 2) {
                    locale = 'it';
                }
                return function (d, type, row) {

                    var m = window.moment(d, from, locale, true);

                    // Order and type get a number value from Moment, everything else        // sees the rendered value
                    return m.format(type === 'sort' || type === 'type' ? 'x' : to);
                };
            };

            $('#tblElencoAudit').DataTable().destroy();
            $('#tblElencoAudit tbody').html("<tr><td></td></tr>")

            tblElencoAudit = $('#tblElencoAudit').DataTable({
                processing: true,
                serverSide: false,
                pageLength: 500,
                order: [[4, 'desc']],   //se devo ordinare
                ajax:
                {
                    type: "POST",
                    dataType: 'json',
                    url: "../Control/ws_DatiAudit.asmx/GetListDatiAudit",
                    data:
                    {

                    },
                    dataSrc: function (json) {
                       //   alert("Done!");
                        return json.data;
                    },
                    error: function (xhr, status, error) {
                        var errorMessage = xhr.status + ': ' + xhr.statusText
                        alert('Error - ' + errorMessage);
                    }
                },
                dom: '<"H"<"left-col"rB><".right{float:right;}"f>>t<"F"i>',
                columnDefs: [{ target: "_all", className: "dt-control" }],
                columns: [
                    { data: "ID", className: "text-center", visible: false },
                    { data: "ID", className: "text-center", visible: false },
                    { data: "StabilimentoAudit", className: "text-center", width: "120" },
                    { data: "NumeroAudit", className: "text-center", width: "80" },
                    { data: "AuditData", className: "text-center text-nowrap", render: $.fn.dataTable.render.moment('DD/MM/YYYY') },
                    { data: "Reparto", className: "text-left", width: "500" },
                    { data: "EsitoAudit", className: "text-left", width: "300" },
                    { data: "CheckList", className: "text-left", width: "500" },
                    { data: "RifAC", className: "text-center", width: "80" },
                    {
                        data: "ID", className: "text-center text-nowrap",
                        render: function (data, type, row) {
                            if (data == '') {
                                return "&nbsp;"
                            }
                            else {
                                return '<div class="fa fa-pencil btnModificaDocumento"></i>';
                            }
                        }

                    }
                ],
                select: false,
                autoWidth: false,
                buttons: [
                    { extend: 'excelHtml5', exportOptions: { columns: ':visible' }, className: 'btn-sm' }
                ],
                language: {
                    url: '../resources/it.json'
                },
            })
        }



        $(document).ready(function () {

            loadElencoAudit()

        })



    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container-fluid">
        <div class="row">

            <div class="col">

<%--                <div class="col">
                    <div class="form-group text-left mb-1">
                        <div id="btnNuovoAudit" class="btn btn-sm btn-primary">Nuovo</div>
                    </div>
                </div>--%>

                <table id="tblElencoAudit" class="compact table table-striped table-bordered" style="width: 100%;">
                    <thead>
                        <tr>
                            <th></th>
                            <th></th>
                            <th>Stabilimento</th>
                            <th>Numero</th>
                            <th>Data Audit</th>
                            <th>Reparto</th>
                            <th>Esito</th>
                            <th>Check List</th>
                            <th>AC</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>

            </div>
        </div>
    </div>


</asp:Content>
