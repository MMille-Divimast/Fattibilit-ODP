table 50040 "Prod. Order Feasibility PTE"
{
    Caption = 'Prod. Order Feasibility';
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
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            ToolTip = 'Specifies the line number of the production order.';
        }
        field(11; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            ToolTip = 'Specifies the item no. to be produced through the production order.';
        }
        field(12; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."),
                                                       Code = field("Variant Code"));
            ToolTip = 'Specifies the variant code for production order item.';
        }
        field(20; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
            ToolTip = 'Specifies the location code to which you want to post the finished product from this production order.';
        }
        field(47; "Due Date"; Date)
        {
            Caption = 'Due Date';
            ToolTip = 'Specifies the due date of the production order.';
        }
        field(48; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            ToolTip = 'Specifies the starting date of the production order.';
        }
        field(49; "Starting Time"; Time)
        {
            Caption = 'Starting Time';
            ToolTip = 'Specifies the starting time of the production order.';
        }
        field(50; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            ToolTip = 'Specifies the ending date of the production order.';
        }
        field(51; "Ending Time"; Time)
        {
            Caption = 'Ending Time';
            ToolTip = 'Specifies the ending time of the production order.';
        }
        field(80; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
            ToolTip = 'Specifies the base unit used to measure the item.';
        }
        field(1000; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            Editable = false;
            ToolTip = 'Specifies the item description.';
        }
        field(1010; "Planning Group"; Code[10])
        {
            Caption = 'Planning Group';
            TableRelation = "Planning Groups FLE";
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
            ToolTip = 'Specifies the standard task.';
        }
        field(2000; "Ext. Feasible Quantity (Base)"; Decimal)
        {
            Caption = 'Ext. Feasible Quantity (Base)';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the quantity of the item that can be produced externally in the production order, based on the external inventory of the components.';
        }
        field(2001; "Int. Feasible Quantity (Base)"; Decimal)
        {
            Caption = 'Int. Feasible Quantity (Base)';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the quantity of the item that can be produced internally in the production order, based on the internal inventory of the components.';
        }
        field(2002; "Tot. Feasible Quantity (Base)"; Decimal)
        {
            Caption = 'Tot. Feasible Quantity (Base)';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the total quantity of the item that can be produced in the production order, regardless of whether it is manufactured internally or externally.';
        }
        field(2004; "TS Feasible Quantity (Base)"; Decimal)
        {
            Caption = 'Feasible Quantity With Transfer (Base)';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the quantity that can be produced by creating a transfer order from internal location to external location.';
        }
        field(2010; "Order Status"; Code[1])
        {
            Caption = 'Order Status';
            ToolTip = 'Specifies the status of the production order.';
        }
        field(2020; "Full Feasible Externally"; Boolean)
        {
            Caption = 'Full Feasible Externally';
            ToolTip = 'Specifies whether the production order can be fully produced externally.';
        }
        field(2030; "Full Feasible"; Boolean)
        {
            Caption = 'Full Feasible';
            ToolTip = 'Specifies whether the production order can be fully produced.';
        }
        field(2031; "Full Feasible Transfer"; Boolean)
        {
            Caption = 'Full Feasible with Transfer';
            ToolTip = 'Specifies whether the production order can be fully produced with transfer order.';
        }
        field(2040; "Partially Feasible"; Boolean)
        {
            Caption = 'Partially Feasible';
            ToolTip = 'Specifies whether the production order can be produced only partially.';
        }
        //TODO campi che iniziano per 50... capire se tenerli o no
        field(50905; "Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
            Description = 'PLA220308C1 numerazione per non creare conflitti con T5406';
            TableRelation = "Purchase Header"."No." where("Document Type" = const(Order),
                                                          "Subcontracting Order" = const(true));
            ToolTip = 'Specifies the purchase order no. linked to the production order.';

        }
        field(50906; "Purchase Order Line No."; Integer)
        {
            Caption = 'Purchase Order Line No.';
            Description = 'PLA220308C1 numerazione per non creare conflitti con T5406';
            TableRelation = "Purchase Line"."Line No." where("Document Type" = const(Order),
                                                              "Document No." = field("Purchase Order No."));
            ToolTip = 'Specifies the purchase order line no. linked to the production order.';
        }
        field(50911; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            Description = 'PLA220308C1 numerazione per non creare conflitti con T5406';
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order),
                                                        "No." = field("Sales Order No."));
            ToolTip = 'Specifies the sales order no. linked to the production order.';
        }
        field(50912; "Sales Order Line No."; Integer)
        {
            BlankZero = true;
            Caption = 'Sales Order Line No.';
            Description = 'PLA220308C1 numerazione per non creare conflitti con T5406';
            TableRelation = "Sales Line" where("Document Type" = const(Order),
                                                "Document No." = field("Sales Order No."),
                                                "Line No." = field("Sales Order Line No."));
            ToolTip = 'Specifies the sales order line no. linked to the production order.';
        }
        field(50913; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            Description = 'PLA220308C1 numerazione per non creare conflitti con T5406';
            TableRelation = Customer;
            ToolTip = 'Specifies the customer for whom the production order was created. If the field is blank, the order was not created for a sales order.';
        }
        field(80081; "Operation Quantity (Base)"; Decimal)
        {
            Caption = 'Operation Quantity (Base)';
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the quantity to produce for the routing operation specified on the line.';
        }
        field(80082; "Operation Finished Qty. (Base)"; Decimal)
        {
            Caption = 'Operation Finished Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            ToolTip = 'Specifies the finished quantity for the routing operation specified on the line.';
        }
        field(80083; "Operation Rem. Qty. (Base)"; Decimal)
        {
            Caption = 'Operation Remaining Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            ToolTip = 'Specifies the remaining quantity for the routing operation specified on the line.';
        }
    }

    keys
    {
        //TODO: in chiave inserire anche lo stato?
        key(Key1; "Prod. Order No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Order Status", "Due Date", "Prod. Order No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}