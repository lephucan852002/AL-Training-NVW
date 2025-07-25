page 50511 "Synchronize Headers"
{
    PageType = Document;
    SourceTable = "Synchronize Header";
    Caption = 'Synchronize Document';
    UsageCategory = Documents;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
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

            part(Lines; "Synchronize Line")
            {
                ApplicationArea = All;
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("Document No.");
            }
        }
    }
}
