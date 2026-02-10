table 50041 "TMP Subc. Feasibility 1 PTE"
{
    Caption = 'TMP Subcontactor Feasibility 1';
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
        field(3; "Prod. Order Line No."; Integer)
        {
            Caption = 'Prod. Order Line No.';
            TableRelation = "Prod. Order Line"."Line No." where(Status = field(Status),
                                                                 "Prod. Order No." = field("Prod. Order No."));
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(11; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(13; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(19; "Routing Link Code"; Code[10])
        {
            Caption = 'Routing Link Code';
            TableRelation = "Routing Link";
        }
        field(21; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
        }
        field(30; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(45; "Quantity per"; Decimal)
        {
            Caption = 'Quantity per';
            DecimalPlaces = 0 : 5;
        }
        field(60; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(61; "Remaining Qty. (Base)"; Decimal)
        {
            Caption = 'Remaining Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(62; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(73; "Expected Qty. (Base)"; Decimal)
        {
            Caption = 'Expected Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(1000; "Component Description"; Text[100])
        {
            Caption = 'Component Description';
            Editable = false;
        }
        field(1010; "Location Inventory"; Decimal) //TODO da eliminare
        {
            Caption = 'Location Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(1020; "Planning Group"; Code[10])
        {
            Caption = 'Planning Group';
            TableRelation = "Planning Groups FLE".Code;
        }
        field(1025; "External Location"; Code[10])
        {
            Caption = 'External Location';
            TableRelation = Location where("Use As In-Transit" = const(false));
            Editable = false;
        }
        field(1030; "External Inventory"; Decimal)
        {
            Caption = 'External Inventory';
            DecimalPlaces = 0 : 5;
            Description = 'PLA00';
            Editable = false;
        }
        field(1035; "Internal Location"; Code[10])
        {
            Caption = 'Internal Location';
            TableRelation = Location where("Use As In-Transit" = const(false));
            Editable = false;
        }
        field(1040; "Internal Inventory"; Decimal)
        {
            Caption = 'Internal Inventory';
            DecimalPlaces = 0 : 5;
            Description = 'PLA00';
            Editable = false;
        }
        field(1045; "Internal Inventory Other Loc."; Decimal)
        {
            Caption = 'Internal Inventory Other Loc.';
            DecimalPlaces = 0 : 5;
            Description = 'PLA00';
            Editable = false;
        }
        field(1050; "Qty. in Transfer Order"; Decimal)
        {
            Caption = 'Qty. in Transfer Order';
            DecimalPlaces = 0 : 5;
            Description = 'PLA00';
        }
        field(1060; "Global Inventory"; Decimal)
        {
            Caption = 'Global Inventory';
            DecimalPlaces = 0 : 5;
            Description = 'PLA00';
            Editable = false;
        }
        field(1065; "Expected Receipt Qty. (Base)"; Decimal)
        {
            Caption = 'Expected Receipt Quantity (Base)'; //TODO Caption in italiano: “Quantità in ingresso prevista”
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(1070; "Subc. Reserved Quantity (Base)"; Decimal)
        {
            Caption = 'Subc. Reserved Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Description = 'PLA00';
        }
        field(1075; "Int. Reserved Quantity (Base)"; Decimal)
        {
            Caption = 'Int. Reserved Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Description = 'PLA00';
        }
        field(1080; "Subc. Qty. used Other (Base)"; Decimal)
        {
            Caption = 'Subc. Qty. used Other (Base)';
            DecimalPlaces = 0 : 5;
            Description = 'PLA00';
        }
        field(1085; "Int. Qty. used Other (Base)"; Decimal)
        {
            Caption = 'Int. Qty. used Other (Base)';
            DecimalPlaces = 0 : 5;
            Description = 'PLA00';
        }
        field(1086; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            Description = 'PLA00';
            TableRelation = "Unit of Measure";
            ValidateTableRelation = false;
        }
        field(1087; "Critical Component"; Boolean)//! Mai usato
        {
            Caption = 'Critical Component';
            Description = 'PLA00';
        }
        field(1088; "Item Tracking Code"; Code[10])
        {
            Caption = 'Item Tracking Code';
            Description = 'PLA00';
            TableRelation = "Item Tracking Code";
        }
        field(1089; "Inventory Posting Group"; Code[20])
        {
            Caption = 'Inventory Posting Group';
            Description = 'PLA00';
            TableRelation = "Inventory Posting Group";
        }
        field(1090; "Total Subc. Rem. Qty. (Base)"; Decimal)
        {
            Caption = 'Total Subcontractor Remaining Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Description = 'PLA00';
            Editable = false;
        }
        field(1091; "Qty. on Int. Component Lines"; Decimal)
        {
            BlankZero = true;
            Caption = 'Qty. on Int. Component Lines';
            DecimalPlaces = 0 : 5;
            Description = 'PLA00';
        }
        field(1095; "Partially Feasible"; Boolean)
        {
            Caption = 'Partially Feasible';
            Editable = false;
        }
        field(1096; "Not Feasible"; Boolean)
        {
            Caption = 'Not Feasible';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Item No.", "Variant Code")
        {
        }
    }

    fieldgroups
    {
    }
}