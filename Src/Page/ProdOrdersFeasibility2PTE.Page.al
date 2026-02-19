page 50112 "Prod. Orders Feasibility 2 PTE"
{
    ApplicationArea = All;
    Caption = 'Prod. Orders Feasibility 2';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Prod. Order Feasibility 1 PTE";
    SourceTableTemporary = true;
    SourceTableView = sorting(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.")
                      order(ascending);

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Editable = false;
                FreezeColumn = "Prod. Order No.";
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ApplicationArea = All;
                    AssistEdit = false;
                    DrillDown = false;
                    Lookup = false;
                }
                field("Prod. Order Line No."; Rec."Prod. Order Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("RTMPSubcFeas.Subcontractor"; RTempProdOrderFeasibility.Subcontractor)
                {
                    ApplicationArea = All;
                    Caption = 'Subcontractor';
                }
                field("Subcontractor Name"; RTempProdOrderFeasibility."Subcontractor Name")
                {
                    ApplicationArea = All;
                    Caption = 'Subcontractor Name';
                }
                field("Item No."; RTempProdOrderFeasibility."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                }
                field("Variant Code"; RTempProdOrderFeasibility."Variant Code")
                {
                    ApplicationArea = All;
                    Caption = 'Variant Code';
                    Visible = false;
                }
                field("Item Description"; RTempProdOrderFeasibility."Item Description")
                {
                    ApplicationArea = All;
                    Caption = 'Item Description';
                }
                field("Planning Group"; RTempProdOrderFeasibility."Planning Group")
                {
                    ApplicationArea = All;
                    Caption = 'Planning Group';
                    Visible = false;
                }
                field("Due Date"; RTempProdOrderFeasibility."Due Date")
                {
                    ApplicationArea = All;
                    Caption = 'Due Date';
                }
                field("Starting Date"; RTempProdOrderFeasibility."Starting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Starting Date';
                }
                field("Ending Date"; RTempProdOrderFeasibility."Ending Date")
                {
                    ApplicationArea = All;
                    Caption = 'Ending Date';
                }
                field("Unit of Measure Code"; RTempProdOrderFeasibility."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    AssistEdit = false;
                    Caption = 'Unit of Measure Code';
                    DrillDown = false;
                    Lookup = false;
                    Visible = false;
                }
                field("Quantity (Base)"; RTempProdOrderFeasibility."Operation Quantity (Base)")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Quantity (Base)';
                }
                field("Finished Qty. (Base)"; RTempProdOrderFeasibility."Operation Finished Qty. (Base)")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Finished Qty. (Base)';
                }
                field("Remaining Qty. (Base)"; RTempProdOrderFeasibility."Operation Rem. Qty. (Base)")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Remaining Qty. (Base)';
                }
                field("Feasible Quantity (Base)"; RTempProdOrderFeasibility."Ext. Feasible Quantity (Base)")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Feasible Quantity (Base)';
                }
                // field("RTMPSubcFeas.""Subcontractor Order"""; RTMPSubcFeas."Subcontractor Order")
                // {
                //     ApplicationArea = All;
                //     Caption = '1st Subcontractor Order';
                // }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(A_ItemCard)
            {
                ApplicationArea = All;
                Caption = 'Item Card';
                Image = EditLines;
                ShortcutKey = 'Shift+Ctrl+C';

                trigger OnAction()
                var
                    L_RItem: Record Item;
                    L_PGItemCard: Page "Item Card";
                begin
                    if L_RItem.Get(RTempProdOrderFeasibility."Item No.") then begin
                        L_PGItemCard.SetRecord(L_RItem);
                        L_PGItemCard.Editable(false);
                        L_PGItemCard.Run();
                    end
                end;
            }
            action(A_Disponibilita)
            {
                ApplicationArea = All;
                Caption = 'Availability';
                Image = Trace;
                ShortcutKey = 'Return';

                trigger OnAction()
                var
                    L_CProduction: Codeunit "Production Codeunit FLE";
                begin
                    if Rec."Item No." <> '' then
                        L_CProduction.ShowItemAvailability(RTempProdOrderFeasibility."Item No.", '', '');
                end;
            }
            //TODO elimina prima del commit
            action(ProdOrderNoAsFilterString)
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    L_RTempProdOrderFeasibility1: Record "Prod. Order Feasibility 1 PTE" temporary;
                    L_Message: Text;
                begin
                    L_RTempProdOrderFeasibility1.Copy(Rec, true);
                    if L_RTempProdOrderFeasibility1.FindSet() then
                        repeat
                            if L_Message = '' then
                                L_Message := L_RTempProdOrderFeasibility1."Prod. Order No."
                            else
                                L_Message := L_Message + '|' + L_RTempProdOrderFeasibility1."Prod. Order No.";
                        until L_RTempProdOrderFeasibility1.Next() = 0;

                    Message(L_Message);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if not RTempProdOrderFeasibility.Get(Rec."Prod. Order No.", Rec."Prod. Order Line No.") then
            Clear(RTempProdOrderFeasibility);
    end;

    var
        RTempProdOrderFeasibility: Record "Prod. Order Feasibility PTE" temporary;

    procedure GetTmpRec(var V_RTempProdOrderFeasibility: Record "Prod. Order Feasibility PTE"; var V_RTempProdOrderFeasibility1: Record "Prod. Order Feasibility 1 PTE")
    begin
        Rec.Copy(V_RTempProdOrderFeasibility1, true);
        RTempProdOrderFeasibility.Copy(V_RTempProdOrderFeasibility, true);
        exit;
    end;
}
