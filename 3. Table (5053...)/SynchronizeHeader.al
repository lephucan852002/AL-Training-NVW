table 50530 "Synchronize Header"
{
    Caption = 'Synchronize Header';
    DataClassification = CustomerContent;

    fields
    {
        field(10; "Document Type"; Enum "Synchronize Document Type")
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(20; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(30; "Document Type Description"; Text[50])
        {
            Caption = 'Document Type Description';
            DataClassification = CustomerContent;
        }
        field(40; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            DataClassification = CustomerContent;
        }
        field(50; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }


    }

    keys
    {
        key(PK; "Document Type", "Document No.")
        {
            Clustered = true;
        }
    }

}