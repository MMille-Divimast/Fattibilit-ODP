page 50112 "Subcontactor Feasibility 2 PTE"
{
    // PT20130157 20/12/2013 CS Creazione

    Caption = 'Subcontactor Global Feasibility 2';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    // PromotedActionCategories = 'New,Process,Report,Filters,Cards';
    SourceTable = "TMP Subc. Feasibility 1 PTE";
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
                    AssistEdit = false;
                    DrillDown = false;
                    Lookup = false;
                    ApplicationArea = All;
                }
                field("Prod. Order Line No."; Rec."Prod. Order Line No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("RTMPSubcFeas.Subcontractor"; RTMPSubcFeas.Subcontractor)
                {
                    Caption = 'Subcontractor';
                    ApplicationArea = All;
                }
                field("RTMPSubcFeas.""Subcontractor Name"""; RTMPSubcFeas."Subcontractor Name")
                {
                    Caption = 'Subcontractor Name';
                    ApplicationArea = All;
                }
                field("RTMPSubcFeas.""Item No."""; RTMPSubcFeas."Item No.")
                {
                    Caption = 'Item No.';
                    ApplicationArea = All;
                }
                field("RTMPSubcFeas.""Variant Code"""; RTMPSubcFeas."Variant Code")
                {
                    Caption = 'Variant Code';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("RTMPSubcFeas.""Item Description"""; RTMPSubcFeas."Item Description")
                {
                    Caption = 'Item Description';
                    ApplicationArea = All;
                }
                field("RTMPSubcFeas.""Planning Group"""; RTMPSubcFeas."Planning Group")
                {
                    Caption = 'Planning Group';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("RTMPSubcFeas.""Due Date"""; RTMPSubcFeas."Due Date")
                {
                    Caption = 'Due Date';
                    ApplicationArea = All;
                }
                field("RTMPSubcFeas.""Starting Date"""; RTMPSubcFeas."Starting Date")
                {
                    Caption = 'Starting Date';
                    ApplicationArea = All;
                }
                field("RTMPSubcFeas.""Ending Date"""; RTMPSubcFeas."Ending Date")
                {
                    Caption = 'Ending Date';
                    ApplicationArea = All;
                }
                field("RTMPSubcFeas.""Unit of Measure Code"""; RTMPSubcFeas."Unit of Measure Code")
                {
                    AssistEdit = false;
                    Caption = 'Unit of Measure Code';
                    DrillDown = false;
                    Lookup = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("RTMPSubcFeas.""Quantity (Base)"""; RTMPSubcFeas."Operation Quantity (Base)")
                {
                    BlankZero = true;
                    Caption = 'Quantity (Base)';
                    ApplicationArea = All;
                }
                field("RTMPSubcFeas.""Finished Qty. (Base)"""; RTMPSubcFeas."Operation Finished Qty. (Base)")
                {
                    BlankZero = true;
                    Caption = 'Finished Qty. (Base)';
                    ApplicationArea = All;
                }
                field("RTMPSubcFeas.""Remaining Qty. (Base)"""; RTMPSubcFeas."Operation Rem. Qty. (Base)")
                {
                    BlankZero = true;
                    Caption = 'Remaining Qty. (Base)';
                    ApplicationArea = All;
                }
                field("RTMPSubcFeas.""Feasible Quantity (Base)"""; RTMPSubcFeas."Subc. Feasible Quantity (Base)")
                {
                    BlankZero = true;
                    Caption = 'Feasible Quantity (Base)';
                    ApplicationArea = All;
                }
                field("RTMPSubcFeas.""Subcontractor Order"""; RTMPSubcFeas."Subcontractor Order")
                {
                    Caption = '1st Subcontractor Order';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(A_ItemCard)
            {
                Caption = 'Item Card';
                Image = EditLines;
                ShortcutKey = 'Shift+Ctrl+C';
                ApplicationArea = All;

                trigger OnAction()
                var
                    L_RItem: Record Item;
                    L_PGItemCard: Page "Item Card";
                begin
                    if L_RItem.Get(RTMPSubcFeas."Item No.") then begin
                        L_PGItemCard.SetRecord(L_RItem);
                        L_PGItemCard.Editable(false);
                        L_PGItemCard.Run();
                    end
                end;
            }
            action(A_Disponibilita)
            {
                Caption = 'Availability';
                Image = Trace;
                ShortcutKey = 'Return';
                ApplicationArea = All;

                trigger OnAction()
                var
                    L_CProduction: Codeunit "Production Codeunit FLE";
                begin
                    if Rec."Item No." <> '' then
                        L_CProduction.ShowItemAvailability(RTMPSubcFeas."Item No.", '', '');
                end;
            }
            action(ShowComplete)
            {
                Caption = 'Show Completed';
                Enabled = not ShowComplete;
                Image = ClearFilter;
                Visible = not ShowComplete;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ShowComplete := true;
                    F_SetFilters();
                    CurrPage.Update();
                end;
            }
            action(HideComplete)
            {
                Caption = 'Hide Completed';
                Enabled = ShowComplete;
                Image = UseFilters;
                Visible = ShowComplete;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ShowComplete := false;
                    F_SetFilters();
                    CurrPage.Update();
                end;
            }
            //TODO elimina prima del commit
            action(ProdOrderNoAsFilterString)
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    L_RTMPSubcFeasibility1: Record "TMP Subc. Feasibility 1 PTE" temporary;
                    L_Message: Text;
                begin
                    L_RTMPSubcFeasibility1.Copy(Rec, true);
                    if L_RTMPSubcFeasibility1.FindSet() then
                        repeat
                            if L_Message = '' then
                                L_Message := L_RTMPSubcFeasibility1."Prod. Order No."
                            else
                                L_Message := L_Message + '|' + L_RTMPSubcFeasibility1."Prod. Order No.";
                        until L_RTMPSubcFeasibility1.Next() = 0;

                    Message(L_Message);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if not RTMPSubcFeas.Get(Rec."Prod. Order No.", Rec."Prod. Order Line No.") then
            Clear(RTMPSubcFeas);
    end;

    trigger OnFindRecord(Which: Text): Boolean
    var
        EOF: Boolean;
        i: Integer;
        L_Direction: Integer;
    begin
        for i := 1 to StrLen(Which) do begin
            EOF := false;
            case CopyStr(Which, i, 1) of
                '-', '>':
                    L_Direction := 1;
                '+', '<':
                    L_Direction := -1;
                '=':
                    L_Direction := 0;
            end;
            EOF := not Rec.Find(CopyStr(Which, i, 1));
            while (not EOF) and (not F_ShowRecord()) do
                EOF := Rec.Next(L_Direction) = 0;
            if not EOF then
                exit(true);
        end;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    var
        EOF: Boolean;
        L_Direction: Integer;
        L_NoOfSteps: Integer;
        L_StepsTaken: Integer;
    begin
        L_Direction := 1;
        if Steps < 0 then
            L_Direction := -1;
        L_NoOfSteps := Abs(Steps);
        while (L_StepsTaken < L_NoOfSteps) and (not EOF) do begin
            EOF := Rec.Next(L_Direction) = 0;
            if (not EOF) and F_ShowRecord() then
                L_StepsTaken += 1;
        end;
        exit(L_Direction * L_StepsTaken);
    end;

    var
        RTMPSubcFeas: Record "TMP Subc. Feasibility PTE" temporary;
        ShowComplete: Boolean;


    procedure GetTmpRec(var V_RTMPSubcFeas: Record "TMP Subc. Feasibility PTE"; var V_RTMPSubcFeas1: Record "TMP Subc. Feasibility 1 PTE")
    begin
        Rec.Copy(V_RTMPSubcFeas1, true);
        RTMPSubcFeas.Copy(V_RTMPSubcFeas, true);
        exit;
    end;

    local procedure F_SetFilters()
    begin
    end;


    procedure F_ShowRecord(): Boolean
    begin
        if ShowComplete then
            exit(true)
        else begin
            if not RTMPSubcFeas.Get(Rec."Prod. Order No.", Rec."Prod. Order Line No.") then
                Clear(RTMPSubcFeas);
            if RTMPSubcFeas."Subcontractor Order" = '' then
                exit(true)
            else
                exit(false);
        end;
    end;
}


