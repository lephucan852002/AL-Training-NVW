codeunit 50551 SalesOrderPaymentDueDateMgmt
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Payment Terms Code', false, false)]
    local procedure OnPaymentTermsCodeValidate(var Rec: Record "Sales Header")
    begin
        UpdatePaymentDueDate(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Document Date', false, false)]
    local procedure OnDocumentDateValidate(var Rec: Record "Sales Header")
    begin
        UpdatePaymentDueDate(Rec);
    end;

    local procedure UpdatePaymentDueDate(var SalesHeader: Record "Sales Header")
    var
        PaymentTerms: Record "Payment Terms";
    begin
        if SalesHeader."Payment Terms Code" = '' then begin
            SalesHeader."Payment Due Date" := 0D;
            exit;
        end;

        if SalesHeader."Document Date" = 0D then
            SalesHeader."Document Date" := WorkDate();

        if PaymentTerms.Get(SalesHeader."Payment Terms Code") then
            SalesHeader."Payment Due Date" := CalcDate(PaymentTerms."Due Date Calculation", SalesHeader."Document Date")
        else
            SalesHeader."Payment Due Date" := 0D;
    end;
}