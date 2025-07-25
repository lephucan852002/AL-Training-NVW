tableextension 50540 SalesHeaderExtension extends "Sales Header"
{
    fields
    {
        field(50100; Cancelled; Boolean)
        {
            Caption = 'Cancelled';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                ConfirmCancel: Boolean;
                ConfirmLabel: Label 'Are you sure cancel this Sales Order?';
                UncancelLabel: Label 'Sales Order is no longer marked as Cancelled.';
            begin

                if Cancelled and not xRec.Cancelled then begin
                    ConfirmCancel := Confirm(ConfirmLabel);
                    if not ConfirmCancel then begin
                        Cancelled := false;
                        exit;
                    end;

                    DeleteSalesLines();
                end;


                if not Cancelled and xRec.Cancelled then begin
                    Message(UncancelLabel);

                end;
            end;
        }
        field(50200; "Payment Due Date"; Date)
        {
            Caption = 'Payment Due Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }

    local procedure DeleteSalesLines()
    var
        SalesLine: Record "Sales Line";
        SuccessLabel: Label 'Cancel Successfully';
    begin
        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "No.");

        if SalesLine.FindSet() then
            SalesLine.DeleteAll();

        "Status" := "Status"::Open;

        Modify(true);

        Message(SuccessLabel);
    end;
}
