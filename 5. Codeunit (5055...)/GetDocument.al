codeunit 50550 "GetDocument"
{
    procedure InsertSalesData(FromDate: Date; ToDate: Date)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SyncHeader: Record "Synchronize Header";
        SyncLine: Record "Synchronize Line";
        DocumentType: Enum "Synchronize Document Type";
    begin

        SalesHeader.SetFilter("Document Type", '%1|%2', SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice);
        SalesHeader.SetRange(Status, SalesHeader.Status::Released);
        SalesHeader.SetRange("Document Date", FromDate, ToDate);

        if SalesHeader.FindSet() then
            repeat
                if SalesHeader."No." <> '' then begin

                    if not SyncHeader.Get(DocumentType::"Sales Order", SalesHeader."No.") then begin
                        SyncHeader.Init();
                        SyncHeader."Document Type" := DocumentType::"Sales Order";
                        SyncHeader."Document No." := SalesHeader."No.";
                        SyncHeader.Insert();
                    end;

                    SyncHeader."Document Type Description" := 'Sales ' + Format(SalesHeader."Document Type");
                    SyncHeader."Total Amount" := SalesHeader.Amount;
                    SyncHeader."Posting Date" := SalesHeader."Posting Date";
                    SyncHeader.Modify();


                    SyncLine.SetRange("Document Type", DocumentType::"Sales Order");
                    SyncLine.SetRange("Document No.", SalesHeader."No.");
                    SyncLine.DeleteAll();

                    SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                    SalesLine.SetRange("Document No.", SalesHeader."No.");
                    if SalesLine.FindSet() then
                        repeat
                            SyncLine.Init();
                            SyncLine."Document Type" := DocumentType::"Sales Order";
                            SyncLine."Document No." := SalesLine."Document No.";
                            SyncLine."Line No." := SalesLine."Line No.";
                            SyncLine."Item No." := SalesLine."No.";
                            SyncLine."Item Description" := SalesLine.Description;
                            SyncLine.Quantity := SalesLine.Quantity;
                            SyncLine."Unit Price" := SalesLine."Unit Price";
                            SyncLine."Line Amount" := SalesLine.Amount;
                            SyncLine.Insert();
                        until SalesLine.Next() = 0;
                end;
            until SalesHeader.Next() = 0;
    end;

    procedure InsertPurchaseData(FromDate: Date; ToDate: Date)
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        SyncHeader: Record "Synchronize Header";
        SyncLine: Record "Synchronize Line";
        DocumentType: Enum "Synchronize Document Type";
    begin

        PurchaseHeader.SetFilter("Document Type", '%1|%2', PurchaseHeader."Document Type"::Order, PurchaseHeader."Document Type"::Invoice);
        PurchaseHeader.SetRange(Status, PurchaseHeader.Status::Released);
        PurchaseHeader.SetRange("Document Date", FromDate, ToDate);

        if PurchaseHeader.FindSet() then
            repeat
                if PurchaseHeader."No." <> '' then begin
                    // Process Header
                    if not SyncHeader.Get(DocumentType::"Purchase Order", PurchaseHeader."No.") then begin
                        SyncHeader.Init();
                        SyncHeader."Document Type" := DocumentType::"Purchase Order";
                        SyncHeader."Document No." := PurchaseHeader."No.";
                        SyncHeader.Insert();
                    end;

                    SyncHeader."Document Type Description" := 'Purchase ' + Format(PurchaseHeader."Document Type");
                    SyncHeader."Total Amount" := PurchaseHeader.Amount;
                    SyncHeader."Posting Date" := PurchaseHeader."Posting Date";
                    SyncHeader.Modify();


                    SyncLine.SetRange("Document Type", DocumentType::"Purchase Order");
                    SyncLine.SetRange("Document No.", PurchaseHeader."No.");
                    SyncLine.DeleteAll();

                    PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
                    PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                    if PurchaseLine.FindSet() then
                        repeat
                            SyncLine.Init();
                            SyncLine."Document Type" := DocumentType::"Purchase Order";
                            SyncLine."Document No." := PurchaseLine."Document No.";
                            SyncLine."Line No." := PurchaseLine."Line No.";
                            SyncLine."Item No." := PurchaseLine."No.";
                            SyncLine."Item Description" := PurchaseLine.Description;
                            SyncLine.Quantity := PurchaseLine.Quantity;
                            SyncLine."Unit Price" := PurchaseLine."Unit Price (LCY)";
                            SyncLine."Line Amount" := PurchaseLine.Amount;
                            SyncLine.Insert();
                        until PurchaseLine.Next() = 0;
                end;
            until PurchaseHeader.Next() = 0;
    end;
}