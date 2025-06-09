<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/View/AuditQASE.Master" CodeBehind="DettaglioAudit.aspx.vb" Inherits="AuditQASE.DettaglioAudit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    function loadStabilimenti() {
            $.post("../Control/ws_Stabilimenti.asmx/ListaStabilimenti",
                {
                },
                function (data) {
                    var json = data.data;
                    $('#selNomeStabilimento')
                        .find('option')
                        .remove()
                        .end()
                        .append('<option value="...">...</option>')
                        .val("...")

                    $.each(json, function () {
                        $('#selNomeStabilimento')
                            .append('<option value="' + this.Stabilimento + '">' + this.Stabilimento + '</option>')
                            .val(this.Stabilimento)
                    }
                    )
                    $('#selStabilimento').val("...")
                });
        }




</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container-fluid">
        <div class="row">
            <div class="col fw-bold">
                <div class="text-center">
                    <h4 id="txtTitolo1">Rapporto di Audit integrato</h4>
                </div>
            </div>
        </div>
    </div>

    <div class="row ms-2 me-2">

 <%--       <div class="col-11"--%>

                    <!-- Parte tabella inserimento dati generali - primo blocco -->

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
    


</asp:Content>
