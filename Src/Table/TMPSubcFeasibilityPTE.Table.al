table 90146 "TMP Subc. Feasibility PTE"
{
    Caption = 'TMP Subcontactor Feasibility';
    DataClassification = CustomerContent;
    fields
    {
        field(1; Status; Enum "Production Order Status")
        {
            Caption = 'Status';
        }
        field(2; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
            TableRelation = "Production Order"."No." where(Status = field(Status));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(11; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(12; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."),
                                                       Code = field("Variant Code"));
        }
        field(20; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(47; "Due Date"; Date)
        {
            Caption = 'Due Date';
            Editable = false;
        }
        field(48; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(50; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(80; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(80081; "Operation Quantity (Base)"; Decimal)
        {
            Caption = 'Operation Quantity (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(80082; "Operation Finished Qty. (Base)"; Decimal)
        {
            Caption = 'Operation Finished Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(80083; "Operation Rem. Qty. (Base)"; Decimal)
        {
            Caption = 'Operation Remaining Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(1000; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            Editable = false;
        }
        field(1010; "Planning Group"; Code[10])
        {
            Caption = 'Planning Group';
            TableRelation = "Planning Groups FLE";
        }
        field(1020; "Subcontractor Order"; Code[20])
        {
            Caption = '1st Subcontractor Order';
            Editable = true;
        }
        field(1030; Subcontractor; Code[10])
        {
            Caption = 'Subcontractor';
            TableRelation = "Work Center"."No." where("Subcontractor No." = filter(<> ''));
        }
        field(1040; "Subcontractor Name"; Text[50])
        {
            Caption = 'Subcontractor Name';
        }
        field(1050; "Subcontracting Location Code"; Code[10])
        {
            Caption = 'Subcontracting Location Code';
            Description = 'PLA00';
            TableRelation = Location;
        }
        field(1999; "Standard Task Code"; Code[10])
        {
            Caption = 'Standard Task Code';
            TableRelation = "Standard Task";
        }
        field(2000; "Subc. Feasible Quantity (Base)"; Decimal)
        {
            Caption = 'Subc. Feasible Quantity (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(2001; "Int. Feasible Quantity (Base)"; Decimal)
        {
            Caption = 'Int. Feasible Quantity (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(2002; "Glob. Feasible Quantity (Base)"; Decimal)
        {
            Caption = 'Glob. Feasible Quantity (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(2004; "TS Feasible Quantity (Base)"; Decimal)
        {
            Caption = 'TS Feasible Quantity (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(2010; "Status Order"; Code[1])
        {
            Caption = 'Status Order';
        }
        field(2020; "Full Feasible SubC"; Boolean)
        {
            Caption = 'Full Feasible SubC';
        }
        field(2030; "Full Feasible"; Boolean)
        {
            Caption = 'Full Feasible';
        }
        field(2031; "Full Feasible Transfer"; Boolean)
        {
            Caption = 'Full Feasible with Transfer';
        }
        field(2040; "Partially Feasible"; Boolean)
        {
            Caption = 'Partially Feasible';
        }
        field(50901; "Starting Expected Date"; Date)
        {
            Caption = 'Expected Starting Date';
            Description = 'PLA220308C1 numerazione per non creare conflitti con T5406';

            trigger OnValidate()
            var
                L_TErrNoSubcontracting: label 'Document %1 is not a Subcontractor Order';
            begin
                if "Starting Expected Date" <> 0D then
                    Rec."Order Date 2" := "Starting Expected Date"
                else
                    Rec."Order Date 2" := 29991231D;
            end;
        }
        field(50902; "Starting Effective Date"; Date)
        {
            Caption = 'Effective Starting Date';
            Description = 'PLA220308C1 numerazione per non creare conflitti con T5406';

            trigger OnValidate()
            var
                L_TErrNoSubcontracting: label 'Document %1 is not a Subcontractor Order';
            begin
                if "Starting Effective Date" <> 0D then
                    Rec."Order Date 1" := "Starting Effective Date"
                else
                    Rec."Order Date 1" := 29991231D;
            end;
        }
        field(50903; "Order Date 1"; Date)
        {
            Caption = 'Order Date 1';
            Description = 'PLA220308C1 numerazione per non creare conflitti con T5406';
        }
        field(50904; "Order Date 2"; Date)
        {
            Caption = 'Order Date 2';
            Description = 'PLA220308C1 numerazione per non creare conflitti con T5406';
        }
        field(50905; "Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
            Description = 'PLA220308C1 numerazione per non creare conflitti con T5406';
            TableRelation = "Purchase Header"."No." where("Document Type" = const(Order),
                                                           "Subcontracting Order" = const(true));
        }
        field(50906; "Purchase Order Line No."; Integer)
        {
            Caption = 'Purchase Order No.';
            Description = 'PLA220308C1 numerazione per non creare conflitti con T5406';
            TableRelation = "Purchase Line"."Line No." where("Document Type" = const(Order),
                                                              "Document No." = field("Purchase Order No."));
        }
        field(50907; "Comp. Trans. Order Exists"; Boolean)
        {
            Caption = 'Comp. Trans. Order Exists';
            Description = 'PLA220308C1 numerazione per non creare conflitti con T5406';
        }
        field(50908; "Order Date 3"; Date)
        {
            Caption = 'Order Date 3';
            Description = 'PLA220308C1 numerazione per non creare conflitti con T5406';
        }
        field(50911; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            Description = 'PLA220308C1 numerazione per non creare conflitti con T5406';
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order),
                                                        "No." = field("Sales Order No."));
        }
        field(50912; "Sales Order Line No."; Integer)
        {
            BlankZero = true;
            Caption = 'Sales Order Line No.';
            Description = 'PLA220308C1 numerazione per non creare conflitti con T5406';
            TableRelation = "Sales Line" where("Document Type" = const(Order),
                                                "Document No." = field("Sales Order No."),
                                                "Line No." = field("Sales Order Line No."));
        }
        field(50913; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            Description = 'PLA220308C1 numerazione per non creare conflitti con T5406';
            TableRelation = Customer;
        }
        field(50914; "Pallet Item No."; Code[20])
        {
            Caption = 'Pallet Item No.';
            Description = 'PLA220308C1 numerazione per non creare conflitti con T5406';
            TableRelation = Item where("No." = field("Pallet Item No."),
                                        "Item Category Code" = const('P'));
        }
    }

    keys
    {
        key(Key1; "Prod. Order No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Status Order", "Due Date", "Prod. Order No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}


