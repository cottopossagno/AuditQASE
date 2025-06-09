<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/View/AuditQASE.Master" CodeBehind="Default.aspx.vb" Inherits="AuditQASE._Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script>

        var tblElencoAudit
        var editorDatiAudit

        //function loadStabilimenti() {
        //    $.post("../Control/ws_GestioneParametri.asmx/GetListStabilimenti",
        //{
        //},
        //function (data) {
        //    var json = data.data;
        //    $('#SelStabilimento')
        //        .find('option')
        //        .remove()
        //        .end()
        //        .append('<option value="...">...</option>')
        //        .val("...")

        //    $.each(json, function () {
        //        $('#SelStabilimento')
        //            .append('<option value="' + this.Stabilimenti + '">' + this.Stabilimenti + '</option>')
        //            .val(this.Stabilimenti)
        //    }
        //    )
        //    $('#SelStabilimento').val("...")
        //});
        //}


        //Funzioni per menu a tendina Elenco iniziale
        function listSelMenuTendina() {

            $.ajax({
                url: "../Control/ws_GestioneParametri.asmx/GetListStabilimenti",
                type: "POST",
                async: false,
                data:
                {

                },
                success: function (mydata) {
                    //console.log(mydata.data)
                    var selectElement = $("#SelStabilimento").empty();
                    selectElement.append($("<option>").val('%').text('Tutti'));
                    $.each(mydata.data, function (index, tipo) {
                        selectElement.append($("<option>").val(tipo.Stabilimenti).text(tipo.Stabilimenti));
                        
                    });
                },
                error: function (xhr, status, error) {
                    var errorMessage = xhr.status + ': ' + xhr.statusText
                    alert('Error - ' + errorMessage);
                }
            });

            loadElencoAudit()
        }



        /* Funzione per aggiungere Righe in più se premo il pulsantino + su Elenco iniziale*/
        function format(d) {
            // `d` is the original data object for the row
            var RapportoAudit
            if (d.RapportoAudit == null) {
                RapportoAudit = ''
            } else {
                RapportoAudit = d.RapportoAudit
            }


            return (
                '<table cellpadding="5" cellspacing="0" border="0" style="padding-left:50px; ColoreGiallo">' +
                '<tr>' +
                '<td><B>Audit:</B></td>' +
                '<td>' + RapportoAudit + '</td>' +
               
                '</table>'
            );
        }


        function loadElencoAudit() {

            $.fn.dataTable.render.moment = function (from, to, locale) {
                // Argument shifting ARGUMENT S

                if (arguments.length === 1) {
                    locale = 'it'; to = from; from = 'YYYY-MM-DDT00:00:00';
                }
                else if (arguments.length === 2) {
                    locale = 'it';
                }
                return function (d, type, row) {

                    var m = window.moment(d, from, locale, false);

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
                order: [[3, 'desc']],   //se devo ordinare
                ajax:
                {
                    type: "POST",
                    dataType: 'json',
                    url: "../Control/ws_ElencoAudit.asmx/GetListElencoAudit",
                    data:
                    {
                            "StabilimentoAudit":$('#SelStabilimento').val()
                    },
                    dataSrc: function (json) {
                        //  alert("Done!");
                        return json.data;
                    },
                    error: function (xhr, status, error) {
                        var errorMessage = xhr.status + ': ' + xhr.statusText
                        alert('Error - ' + errorMessage);
                    }
                },
                dom: '<"H"<"left-col"Bl><"right-col"f>>t<"F"pri>',
                columnDefs: [{ targets: 0, className: "dt-control" }],
                columns: [
                    { data: null, className: 'dt-control', orderable: false, defaultContent: '' },
                    { data: "ID", className: "text-center", visible: false },
                    { data: "StabilimentoAudit", className: "text-left", width: "200" },
                    { data: "Anno", className: "text-center", width: "50" },
                    { data: "Reparto", className: "text-left", width: "500" },
                    { data: "AuditData", className: "text-center text-nowrap", render: $.fn.dataTable.render.moment('DD/MM/YYYY') },
                    { data: "NumeroAudit", className: "text-center", width: "80" },
                    { data: "AuditEffettuato", className: "text-center", width: "40" },
                    { data: "EsitoAudit", className: "text-left", width: "300" },
                    { data: "AuditScaduto", className: "text-center", width: "40" },
                    { data: "RifAC", className: "text-center", width: "80" },
                    {
                        data: "ID", className: "text-center text-nowrap",
                        render: function (data, type, row) {
                            if (data == '') {
                                return "&nbsp;"
                            }
                            else {
                                return '<div class="fa fa-pencil btnEditRapportoAudit"></i>';
                            }
                        }
                    },
                    { data: "RapportoAudit", className: "text-left text-nowrap", visible: false }
                ],
                select: true,
                autoWidth: false,
                buttons: [
                    { extend: 'excelHtml5', exportOptions: { columns: ':visible' }, className: 'btn-sm' }
                ],
                language: {
                    url: '../resources/it.json'
                },
            })

            // Add event listener for opening and closing details
            $('#tblElencoAudit tbody').on('click', 'td.dt-control', function () {
                var tr = $(this).closest('tr');
                var row = tblElencoAudit.row(tr);

                if (row.child.isShown()) {
                    // This row is already open - close it
                    row.child.hide();
                    tr.removeClass('shown');
                } else {
                    // Open this row
                    row.child(format(row.data())).show();
                    tr.addClass('shown');
                }
            });
        }




        $(document).ready(function () {
            loadElencoAudit()

            $('#SelStabilimento').change(function () {
                loadElencoAudit()
            })

            
            /*loadStabilimenti()*/

            listSelMenuTendina()
        })



    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container-fluid">

        <div class="row">
            <div class="col-3">
                <div class="form-group">
                    <label for="SelStabilimento" class="h6 text-white">Stabilimento</label>
                    <select class="form-group filter" name="SelStabilimento" id="SelStabilimento" style="width: 150px">
                    </select>
                </div>

                <%--<select class="form-group" name="SelStabilimento" id="SelStabilimento" style="width: 200px">
                                <option value="%" selected>Tutti</option>
                                <option value="CUNIAL">CUNIAL</option>
                                <option value="FRATELLI VARDANEGA">FRATELLI VARDANEGA</option>
                                <option value="ILCA">ILCA</option>
                                <option value="MAGAZZINO VENTILATI">MAGAZZINO VENTILATI</option>
                                <option value="MONFENERA">MONFENERA</option>
                                <option value="PRELAVORAZIONI">PRELAVORAZIONI</option>
                                <option value="UFFICI">UFFICI</option>
                                <option value="VARDANEGA ISIDORO">VARDANEGA ISIDORO</option>
                            </select>--%>
            </div>
        </div>

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
                            <th>Anno</th>
                            <th>Reparto</th>
                            <th>Data Audit</th>
                            <th>Numero</th>
                            <th>Effettuato</th>
                            <th>Esito</th>
                            <th>Scaduto</th>
                            <th>AC</th>
                            <th></th>
                            <th>Audit</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>

            </div>
        </div>


        <!-- Modal Rapporto Audit -->
        <div class="modal" id="divShowRapportoAudit" tabindex="-1" role="dialog" aria-labelledby="divShowRapportoAudit" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-fullscreen" role="document">
                <div class="modal-content">
                    <div class=" modal-header text-center ColoreIntestazione">
                        <h4 class="modal-title" id="imgTitolo1">Rapporto di Audit Integrato</h4>

                        <div class="row mt-2 mb-2">
                            <div class="col-12">
                                <div class="row">
                                    <div class="col-12">
                                        <div class="row">
                                            <label class="col-2 fw-bold" for="selNomeStabilimento">STABILIMENTO</label>
                                            <div class="col-2">
                                                <input type="text" class="form-control" id="selNomeStabilimento">
                                            </div>
                                            <label class="col-2 text-center fw-bold" for="txtNumeroAudit">NUMERO</label>
                                            <div class="col-2">
                                                <input type="text" class="form-control" id="txtNumeroAudit">
                                            </div>
                                            <label class="col-2 text-center fw-bold" for="txtDataAudit">DEL</label>
                                            <div class="col-2">
                                                <input type="text" class="form-control" id="txtDataAudit">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row mb-2">
                            <div class="col">
                                <div class="row">
                                    <div class="col">
                                        <div class="row">
                                            <label class="col-2 fw-bold" for="txtReparto">REPARTO</label>
                                            <div class="col-2">
                                                <input type="text" class="form-control" id="txtReparto">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row mb-2">
                            <div class="col-12">
                                <div class="row">
                                    <div class="col-12">
                                        <div class="row">
                                            <label class="col-2 fw-bold" for="txtObiettivi">OBIETTIVI</label>
                                            <div class="col-10">
                                                <input type="text" class="form-control" id="txtObiettivi">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row mb-2">
                            <div class="col">
                                <div class="row">
                                    <div class="col">
                                        <div class="row">
                                            <label class="col-2 fw-bold" for="txtResponsabile">RESPONSABILE</label>
                                            <div class="col-2">
                                                <input type="text" class="form-control" id="txtResponsabile">
                                            </div>
                                            <label class="col-2 text-center fw-bold" for="txtAuditSecondo">AUDIT</label>
                                            <div class="col-2">
                                                <input type="text" class="form-control" id="txtAuditSecondo">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row mb-2">
                            <div class="col-12">
                                <div class="row">
                                    <div class="col-12">
                                        <div class="row">
                                            <label class="col-2 fw-bold" for="txtLeadAuditor">LEAD AUDITOR</label>
                                            <div class="col-10">
                                                <input type="text" class="form-control" id="txtLeadAuditor">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row mb-2">
                            <div class="col">
                                <div class="row">
                                    <div class="col">
                                        <div class="row">
                                            <label class="col-2 fw-bold" for="txtTeamAudit1">TEAM AUDIT</label>
                                            <div class="col-2">
                                                <input type="text" class="form-control" id="txtTeamAudit1">
                                            </div>
                                            <div class="col-2">
                                                <input type="text" class="form-control" id="txtTeamAudit2">
                                            </div>
                                            <div class="col-2">
                                                <input type="text" class="form-control" id="txtTeamAudit3">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row mb-2">
                            <div class="col">
                                <div class="row">
                                    <div class="col">
                                        <div class="row">
                                            <label class="col-2 fw-bold" for="txtIntervistati1">INTERVISTATI</label>
                                            <div class="col-2">
                                                <input type="text" class="form-control" id="txtIntervistati1">
                                            </div>
                                            <div class="col-2">
                                                <input type="text" class="form-control" id="txtIntervistati2">
                                            </div>
                                            <div class="col-2">
                                                <input type="text" class="form-control" id="txtIntervistati3">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row mb-2">
                            <div class="col">
                                <div class="row">
                                    <div class="col">
                                        <div class="row">
                                            <div class="mb-3">
                                                <label for="txtRapporto" class="form-label fw-bold">RAPPORTO</label>
                                                <textarea class="form-control" id="txtRapporto" rows="2"></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row mb-2">
                            <div class="col">
                                <div class="row">
                                    <div class="col">
                                        <div class="row">
                                            <label class="col-2 fw-bold" for="txtCheckList">CHECK LIST</label>
                                            <div class="col-2">
                                                <input type="text" class="form-control" id="txtCheckList">
                                            </div>
                                            <label class="col-2 text-center fw-bold" for="txtAzioneCorrettiva">AZIONE CORRETTIVA</label>
                                            <div class="col-2">
                                                <input type="text" class="form-control" id="txtAzioneCorrettiva">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row mb-2">
                            <div class="col-12">
                                <div class="row">
                                    <div class="col-12">
                                        <div class="row">
                                            <label class="col-2 fw-bold" for="selEsitoAudit">ESITO AUDIT</label>
                                            <div class="col-10">
                                                <input type="text" class="form-control" id="selEsitoAudit">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
