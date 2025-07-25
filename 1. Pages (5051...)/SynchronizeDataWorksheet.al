page 50510 "Synchronize Data Worksheet"
{
    PageType = Worksheet;
    SourceTable = "Synchronize Header";
    Caption = 'Synchronize Data';
    UsageCategory = Tasks;
    ApplicationArea = All;


    layout
    {
        area(Content)
        {
            group("Filter Data Option")
            {
                Caption = 'Filter Data Option';
                field("From Date"; FromDate)
                {
                    ApplicationArea = All;
                    Caption = 'From Date';

                }
                field("To Date"; ToDate)
                {
                    ApplicationArea = All;
                    Caption = 'To Date';

                }
            }

            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    begin
                        PAGE.RunModal(PAGE::"Synchronize Headers", Rec);
                    end;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Document Type Description"; Rec."Document Type Description")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(GetDocuments)
            {
                Caption = 'Get Documents';
                action(GetPurchaseDocuments)
                {
                    // ... (các thuộc tính khác)
                    trigger OnAction()
                    var
                        GetDocument: Codeunit 50550;
                    begin
                        // Truyền tham số FromDate và ToDate (yêu cầu đề bài)
                        if Confirm('Do you want to get purchase documents from %1 to %2?', false, FromDate, ToDate) then begin
                            GetDocument.InsertPurchaseData(FromDate, ToDate);
                            Message('Purchase documents have been synchronized.');
                        end;
                        CurrPage.Update(false);
                    end;
                }
                action(GetSalesDocuments)
                {
                    // ... (các thuộc tính khác)
                    trigger OnAction()
                    var
                        GetDocument: Codeunit 50550;
                    begin
                        // Truyền tham số FromDate và ToDate (yêu cầu đề bài)
                        if Confirm('Do you want to get sales documents from %1 to %2?', false, FromDate, ToDate) then begin
                            GetDocument.InsertSalesData(FromDate, ToDate);
                            Message('Sales documents have been synchronized.');
                        end;
                        CurrPage.Update(false);
                    end;
                }


            }
        }
    }

    trigger OnOpenPage()
    begin
        // Khởi tạo ngày mặc định
        FromDate := Today;
        ToDate := Today;
    end;

    var
        FromDate: Date;
        ToDate: Date;
}