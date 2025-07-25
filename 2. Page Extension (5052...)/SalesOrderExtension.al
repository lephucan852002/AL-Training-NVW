pageextension 50520 SalesOrderPageExt extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            field(Cancelled; Rec.Cancelled)
            {
                ApplicationArea = All;
                Caption = 'Cancelled';
                Editable = true;
            }
        }

        addafter("Invoice Details")
        {
            field("Payment Due Date"; Rec."Payment Due Date")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }

    }

    trigger OnModifyRecord(): Boolean
    begin
        if xRec.Cancelled and Rec.Cancelled then
            Error('Cannot modify a cancelled Sales Order.');
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if Rec.Cancelled then
            Error('Cannot delete a cancelled Sales Order.');
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdatePaymentDueDate();
    end;

    local procedure UpdatePaymentDueDate()
    var
        PaymentTerms: Record "Payment Terms";
    begin
        if Rec."Payment Terms Code" = '' then begin
            Rec."Payment Due Date" := 0D;
            exit;
        end;

        if Rec."Document Date" = 0D then
            Rec."Document Date" := WorkDate();

        if PaymentTerms.Get(Rec."Payment Terms Code") then
            Rec."Payment Due Date" := CalcDate(PaymentTerms."Due Date Calculation", Rec."Document Date")
        else
            Rec."Payment Due Date" := 0D;
    end;
}