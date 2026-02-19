table 50041 "Prod. Order Feasibility 1 PTE"
{
    Caption = 'Prod. Order Feasibility 1';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; Status; Enum "Production Order Status")
        {
            Caption = 'Status';
            ToolTip = 'Specifies the status of the production order.';
        }
        field(2; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
            TableRelation = "Production Order"."No." where(Status = field(Status));
            ToolTip = 'Specifies the number of the production order.';
        }
        field(3; "Prod. Order Line No."; Integer)
        {
            Caption = 'Prod. Order Line No.';
            TableRelation = "Prod. Order Line"."Line No." where(Status = field(Status),
                                                                 "Prod. Order No." = field("Prod. Order No."));
            ToolTip = 'Specifies the line number of the production order.';
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
            ToolTip = 'Specifies the line number of the component.';
        }
        field(11; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            ToolTip = 'Specifies the number of the item that is a component in the production order component list.';
        }
        field(13; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
            ToolTip = 'Specifies how each unit of the item is measured.';
        }
        field(19; "Routing Link Code"; Code[10])
        {
            Caption = 'Routing Link Code';
            TableRelation = "Routing Link";
            ToolTip = 'Specifies the routing link code when you calculate the production order.';
        }
        field(21; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
            ToolTip = 'Specifies the variant of the item on the line.';
        }
        field(30; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
            ToolTip = 'Specifies the location where the component is stored.';
        }
        field(45; "Quantity per"; Decimal)
        {
            Caption = 'Quantity per';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies how many units of the component are required to produce the parent item.';
        }
        field(60; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            ToolTip = 'Specifies how many of the base unit of measure are contained in one unit of the item.';
        }
        field(61; "Remaining Qty. (Base)"; Decimal)
        {
            Caption = 'Remaining Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            ToolTip = 'Specifies the difference between the finished and planned quantities, or zero if the finished quantity is greater than the remaining quantity.';
        }
        field(62; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the quantity of the component required to produce the item in the production order.';
        }
        field(73; "Expected Qty. (Base)"; Decimal)
        {
            Caption = 'Expected Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            ToolTip = 'Specifies the quantity of the component expected to be consumed during the production of the quantity on this line.';
        }
        field(1000; "Component Description"; Text[100])
        {
            Caption = 'Component Description';
            Editable = false;
            ToolTip = 'Specifies a description of the item on the line.';
        }
        field(1020; "Planning Group"; Code[10])
        {
            Caption = 'Planning Group';
            TableRelation = "Planning Groups FLE".Code;
        }
        field(1025; "External Location"; Code[10])
        {
            Caption = 'External Location';
            Editable = false;
            TableRelation = Location where("Use As In-Transit" = const(false));
            ToolTip = 'Specifies the external location where the component inventory is available at the subcontractor.';
        }
        field(1030; "External Inventory"; Decimal)
        {
            Caption = 'External Inventory';
            DecimalPlaces = 0 : 5;
            Description = 'PLA00';
            Editable = false;
            ToolTip = 'Specifies the available external inventory of the component.';
        }
        field(1035; "Internal Location"; Code[10])
        {
            Caption = 'Internal Location';
            Editable = false;
            TableRelation = Location where("Use As In-Transit" = const(false));
            ToolTip = 'Specifies the internal location where the component inventory is available.';
        }
        field(1040; "Internal Inventory"; Decimal)
        {
            Caption = 'Internal Inventory';
            DecimalPlaces = 0 : 5;
            Description = 'PLA00';
            Editable = false;
            ToolTip = 'Specifies the available internal inventory of the component.';
        }
        field(1045; "Internal Inventory Other Loc."; Decimal)
        {
            Caption = 'Internal Inventory Other Loc.';
            DecimalPlaces = 0 : 5;
            Description = 'PLA00';
            Editable = false;
            ToolTip = 'Specifies the internal inventory of the component available in other internal locations than the one specified on the line.';
        }
        field(1050; "Qty. in Transfer Order"; Decimal)
        {
            Caption = 'Qty. in Transfer Order';
            DecimalPlaces = 0 : 5;
            Description = 'PLA00';
            ToolTip = 'Specifies the quantity of the component in transfer orders that have not yet been posted.';
        }
        field(1060; "Global Inventory"; Decimal)
        {
            Caption = 'Global Inventory';
            DecimalPlaces = 0 : 5;
            Description = 'PLA00';
            Editable = false;
            ToolTip = 'Specifies the total inventory of the component, including internal, external, and transfer order quantities.';
        }
        field(1065; "Expected Inbound Qty. (Base)"; Decimal)
        {
            Caption = 'Expected Inbound Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            ToolTip = 'Specifies the expected inbound quantity for the component in the production order. Includes the total from purchase, production, and assembly orders for the component.';
        }
        field(1070; "Ext. Reserved Quantity (Base)"; Decimal)
        {
            Caption = 'Ext. Reserved Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Description = 'PLA00';
            ToolTip = 'Specifies how much external inventory of the component will be reserved to the production order.';
        }
        field(1075; "Int. Reserved Quantity (Base)"; Decimal)
        {
            Caption = 'Int. Reserved Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Description = 'PLA00';
            ToolTip = 'Specifies how much internal inventory of the component will be reserved to the production order.';
        }
        field(1080; "Ext. Quantity Used (Base)"; Decimal)
        {
            Caption = 'Ext. Quantity Used (Base)';
            DecimalPlaces = 0 : 5;
            Description = 'PLA00';
            ToolTip = 'Specifies how much external inventory of the component is already reserved by other production orders with a due date earlier than the current order.';
        }
        field(1085; "Int. Quantity Used (Base)"; Decimal)
        {
            Caption = 'Int. Quantity Used (Base)';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies how much internal inventory of the component is already reserved by other production orders with a due date earlier than the current order.';
        }
        field(1086; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            Description = 'PLA00';
            TableRelation = "Unit of Measure";
            ValidateTableRelation = false;
            ToolTip = 'Specifies how each unit of the item is measured.';
        }
        field(1090; "Total Ext. Rem. Qty. (Base)"; Decimal)
        {
            Caption = 'Total External Remaining Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Description = 'PLA00';
            Editable = false;
            ToolTip = 'Specifies the total remaining quantity of all components identical to the one on the line in all released production orders with a location matching the subcontractor specified.';
        }
        field(1091; "Qty. on Int. Component Lines"; Decimal)
        {
            BlankZero = true;
            Caption = 'Qty. on Int. Component Lines';
            DecimalPlaces = 0 : 5;
            Description = 'PLA00';
            ToolTip = 'Specifies the total remaining quantity of all components identical to the one on the line in all released production orders with the same location as indicated on the line.';
        }
        field(1095; "Partially Feasible"; Boolean)
        {
            Caption = 'Partially Feasible';
            Editable = false;
            ToolTip = 'Specifies whether the component inventory is insufficient to complete the production order.';
        }
        field(1096; "Not Feasible"; Boolean)
        {
            Caption = 'Not Feasible';
            Editable = false;
            ToolTip = 'Specifies whether there is no component inventory available to execute the production order.';
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

    procedure FilterComponentByProdOrder(P_RTempProdOrderFeasibility: Record "Prod. Order Feasibility PTE" temporary)
    begin
        FilterComponentByProdOrder(P_RTempProdOrderFeasibility, Rec);
    end;

    procedure FilterComponentByProdOrder(P_RTempProdOrderFeasibility: Record "Prod. Order Feasibility PTE" temporary; var V_RTempProdOrderFeasibility1: Record "Prod. Order Feasibility 1 PTE")
    begin
        V_RTempProdOrderFeasibility1.SetRange(Status, P_RTempProdOrderFeasibility.Status);
        V_RTempProdOrderFeasibility1.SetRange("Prod. Order No.", P_RTempProdOrderFeasibility."Prod. Order No.");
        V_RTempProdOrderFeasibility1.SetRange("Prod. Order Line No.", P_RTempProdOrderFeasibility."Line No.");
    end;
}