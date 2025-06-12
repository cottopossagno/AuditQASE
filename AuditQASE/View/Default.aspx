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

            $.ajax({
                url: "../Control/ws_SelezioneAnniAudit.asmx/GetListAnniAudit",
                type: "POST",
                async: false,
                data:
                {

                },
                success: function (mydata) {
                    //console.log(mydata.data)
                    var selectElement = $("#SelAnno").empty();
                    selectElement.append($("<option>").val('%').text('Tutti'));
                    $.each(mydata.data, function (index, tipo) {
                        selectElement.append($("<option>").val(tipo.AnnoAudit).text(tipo.AnnoAudit));

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
            if ($.fn.DataTable.isDataTable('#tblElencoAudit')) {
                $('#tblElencoAudit').DataTable().clear().destroy();
            }

            $('#tblElencoAudit tbody').empty();

            //$('#tblElencoAudit').DataTable().destroy();
            $('#tblElencoAudit tbody').html("<tr><td></td></tr>")

            tblElencoAudit = $('#tblElencoAudit').DataTable({
                processing: true,
                serverSide: false,
                lengthMenu: [
                    [10, 25, 50, 100, -1],
                    ['10', '25', '50', '100', 'Tutti']
                ],
                pageLength: 50,
                order: [[3, 'desc']],   //se devo ordinare
                ajax:
                {
                    type: "POST",
                    dataType: 'json',
                    url: "../Control/ws_ElencoAudit.asmx/GetListElencoAudit",
                    data:
                    {
                        "StabilimentoAudit": $('#SelStabilimento').val(),
                        "Anno": $('#SelAnno').val(),
                        "AuditEffettuato": $('#SelAuditEffettuato option:selected').val()
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
                    {
                        data: "AuditEffettuato", className: "text-center", width: "40",
                        render: function (data, type, row) {
                            if (data == 0) {
                                return "<div class='text-center'><img width='24' height='24' src='../Image/red.png' /></div>"
                            }
                            else {
                                return "<div class='text-center'><img width='24' height='24' src='../Image/green.png' /></div>"
                            }
                        }

                    },
                    { data: "EsitoAudit", className: "text-left", width: "300" },
                    {
                        data: "AuditScaduto", className: "text-center", width: "40",
                        render: function (data, type, row) {
                            if (data == 0) {
                                return "<div class='text-center'><img width='24' height='24' src='../Image/green.png' /></div>"
                            }
                            else {
                                return "<div class='text-center'><img width='24' height='24' src='../Image/red.png' /></div>"
                            }
                        }
                    },
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

                drawCallback: function () {
                    $('.btnEditRapportoAudit').on("click", function () {   //evento quando si clicca il pulsante EDIT sulla riga della pagina di default
                        isEditMode = true;

                        var dt = $('#tblElencoAudit').DataTable();
                        dt.column(1).visible(true);
                        var $row = $(this).closest("tr"),        // Finds the closest row <tr>
                            $tds = $row.find("td:nth-child(2)") // Finds the 1 <td> element
                        var SelID = $tds.text()
                        dt.column(1).visible(false);

                        //$('#btnSalvaDatiNuovaNC').hide()
                        //$('#btnSalvaEditNC').show()
                        //$('#divShowPreview').hide();

                        $.post("../Control/ws_DatiAudit.asmx/GetListDatiAudit",
                            {
                                "selID": SelID
                            },
                            function (data) {
                                var json = data.data;
                                //alert(JSON.stringify(json))
                                $("#txtID").val(json.ID);
                                $("#selEditStabUfficio").val(json.StabilimentoAudit).trigger('change');
                                //$("#txtEditNumeroAudit").val(json.NumeroAudit);
                                //$("#txtDataNC").datepicker('setDate', window.moment(json.Data).isValid() ? window.moment(json.Data).format("DD/MM/YYYY") : "").trigger('change');

                                //$("#selEditTipoNC").val(json.TipoNC).trigger('change');
                                //$("#selEditAreaRilevazione").val(json.AreaRilevazione).trigger('change');
                                //$("#txtRilevatoDa").val(json.RilevatoDa);

                                //$("#selEditBreveNC").val(json.BreveNC).trigger('change');
                                //$("#txtDescrizioneNC").val(json.DescrizioneNC);

                                //$("#selEditBreveTrattamento").val(json.BreveTrattamento).trigger('change');
                                //$("#txtTrattamento").val(json.Trattamento);

                                //$("#selEditBreveEfficacia").val(json.Efficacia).trigger('change');
                                //$("#selEditBreveRipetibile").val(json.Ripetibile).trigger('change');

                                //$("#txtCausaNC").val(json.CausaNC);
                                //$("#txtEfficacia").val(json.DescrEfficacia);
                                //$("#txtRipetibile").val(json.RipetibDove);

                                //$("#txtNumeroAC1").val(json.ACnumero1);
                                //$("#txtDataAC1").datepicker('setDate', window.moment(json.ACdel1).isValid() ? window.moment(json.ACdel1).format("DD/MM/YYYY") : "").trigger('change');
                                //$("#txtNumeroAC2").val(json.ACnumero2);
                                //$("#txtDataAC2").datepicker('setDate', window.moment(json.ACdel2).isValid() ? window.moment(json.ACdel2).format("DD/MM/YYYY") : "").trigger('change');
                                //$("#txtNumeroAC3").val(json.ACnumero3);
                                //$("#txtDataAC3").datepicker('setDate', window.moment(json.ACdel3).isValid() ? window.moment(json.ACdel3).format("DD/MM/YYYY") : "").trigger('change');

                                //$("#chkMancanzaComunicazione").prop('checked', json.CarenzaComunicazione);
                                //$("#chkMancanzaFormazione").prop('checked', json.CarenzaFormazione);
                                //$("#chkMancanzaUsoDeiDPI").prop('checked', json.MancatoUsoDeiDPI);

                                //$("#txtNote").val(json.Note);
                                //$("#txtNCChiusaIl").datepicker('setDate', window.moment(json.ChiusaIl).isValid() ? window.moment(json.ChiusaIl).format("DD/MM/YYYY") : "").trigger('change');

                                //$("#selEditCopiaA1").val(json.CopiaA1).trigger('change');
                                //$("#selEditCopiaA2").val(json.CopiaA2).trigger('change');
                                //$("#selEditCopiaA3").val(json.CopiaA3).trigger('change');
                                //$("#selEditCopiaA4").val(json.CopiaA4).trigger('change');
                                //$("#selEditCopiaA5").val(json.CopiaA5).trigger('change');
                                //$("#selEditCopiaA6").val(json.CopiaA6).trigger('change');

                                //$("#txtNCAllegato01").val(json.Allegato1);
                                //$("#txtNCAllegato02").val(json.Allegato2);
                                //$("#txtNCAllegato03").val(json.Allegato3);

                                $('#divShowInsertNC').modal('show');

                            });
                    });
                },

            }
            )

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
            //loadElencoAudit()
            listSelMenuTendina()

            $('#SelStabilimento').change(function () {
                loadElencoAudit()
            })

            $('#SelAnno').change(function () {
                loadElencoAudit()
            })

            $('#SelAuditEffettuato').change(function () {
                loadElencoAudit()
            })

            
        })



    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container-fluid">

        <div class="row">
            <div class="col-4">&nbsp;</div>
            <div class="col">
                <div class="form-group">
                    <label for="SelStabilimento" class="h6">Stabilimento</label>
                    <select class="form-group filter" name="SelStabilimento" id="SelStabilimento" style="width: 150px">
                    </select>

                    <label for="SelAnno" class="h6">Anno</label>
                    <select class="form-group filter" name="SelAnno" id="SelAnno" style="width: 150px">
                    </select>

                    <label for="SelAuditEffettuato" class="h6">Effettuato</label>
                    <select class="form-group filter" name="SelAuditEffettuato" id="SelAuditEffettuato" style="width: 150px">
                        <option value="Tutti" selected>Tutti</option>
                        <option value="Si">Si</option>
                        <option value="No">No</option>
                    </select>

                </div>

            </div>
        </div>

        <div class="row">

            <div class="col">

<%--                <div class="col">
                    <div class="form-group text-left mb-1">
                        <div id="btnNuovoAudit" class="btn btn-sm btn-primary">Nuovo</div>
                    </div>
                </div>--%>

                <table id="tblElencoAudit" class="compact table table-striped table-bordered ColoreVerde" style="width: 100%;">
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
                                            <label class="col-2 fw-bold" for="selEditStabUfficio">STABILIMENTO</label>
                                            <div class="col-2">
                                                <input type="text" class="form-control" id="selNomeStabilimento">
                                            </div>
                                            <label class="col-2 text-center fw-bold" for="txtEditNumeroAudit">NUMERO</label>
                                            <div class="col-2">
                                                <input type="text" class="form-control" id="txtNumeroAudit">
<%--                                            </div>
                                            <label class="col-2 text-center fw-bold" for="txtDataAudit">DEL</label>
                                            <div class="col-2">
                                                <input type="text" class="form-control" id="txtDataAudit">
                                            </div>--%>
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
