page 50111 "Subcontactor Feasibility 1 PTE"
{
    // PT20130157 20/12/2013 CS Creazione

    Caption = 'Subcontactor Global Feasibility 1';
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
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    AssistEdit = false;
                    DrillDown = false;
                    Lookup = false;
                    Visible = false;
                    ApplicationArea = All;
                    StyleExpr = RecStyle;
                }
                field(Status; Rec.Status)
                {
                    Visible = false;
                    ApplicationArea = All;
                    StyleExpr = RecStyle;
                }
                field("Prod. Order Line No."; Rec."Prod. Order Line No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                    StyleExpr = RecStyle;
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                    StyleExpr = RecStyle;
                }
                field("Item No."; Rec."Item No.")
                {
                    AssistEdit = false;
                    DrillDown = false;
                    Lookup = false;
                    ApplicationArea = All;
                    StyleExpr = RecStyle;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                    StyleExpr = RecStyle;
                }
                field("Component Description"; Rec."Component Description")
                {
                    ApplicationArea = All;
                    StyleExpr = RecStyle;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Planning Group"; Rec."Planning Group")
                {
                    Visible = false;
                    ApplicationArea = All;
                }

                //Campi vecchi

                // field("Quantity per"; Rec."Quantity per")
                // {
                //     BlankZero = true;
                //     ApplicationArea = All;
                // }
                // field("Remaining Qty. (Base)"; Rec."Remaining Qty. (Base)")
                // {
                //     BlankZero = true;
                //     ApplicationArea = All;
                // }
                // field("Quantity (Base)"; Rec."Quantity (Base)")
                // {
                //     BlankZero = true;
                //     Visible = false;
                //     ApplicationArea = All;
                // }
                // field("Expected Qty. (Base)"; Rec."Expected Qty. (Base)")
                // {
                //     BlankZero = true;
                //     Visible = false;
                //     ApplicationArea = All;
                // }
                // field("RTMPSubcFeas2.""Available Quantity"""; RTMPSubcFeas2."Available Quantity")
                // {
                //     BlankZero = true;
                //     Caption = 'Available Quantity';
                //     DecimalPlaces = 0 : 5;
                //     ApplicationArea = All;
                // }
                // field(CompFeas; CompFeas)
                // {
                //     BlankZero = true;
                //     Caption = 'Component Feasibility';
                //     DecimalPlaces = 0 : 5;
                //     ApplicationArea = All;
                // }
                // field("Location Inventory"; Rec."Location Inventory")
                // {
                //     BlankZero = true;
                //     ApplicationArea = All;
                // }
                // field("RTMPSubcFeas2.""External Inventory"""; RTMPSubcFeas2."External Inventory")
                // {
                //     BlankZero = true;
                //     Caption = 'External Inventory';
                //     DecimalPlaces = 0 : 5;
                //     ApplicationArea = All;
                // }
                // field("RTMPSubcFeas2.""Internal Inventory"""; RTMPSubcFeas2."Internal Inventory")
                // {
                //     BlankZero = true;
                //     Caption = 'Internal Inventory';
                //     DecimalPlaces = 0 : 5;
                //     ApplicationArea = All;
                // }
                // field("RTMPSubcFeas2.""Global Inventory"""; RTMPSubcFeas2."Global Inventory")
                // {
                //     BlankZero = true;
                //     Caption = 'Global Inventory';
                //     DecimalPlaces = 0 : 5;
                //     ApplicationArea = All;
                // }
                // field("RTMPSubcFeas2.""Sales Orders Quantity"""; RTMPSubcFeas2."Sales Orders Quantity")
                // {
                //     BlankZero = true;
                //     Caption = 'Sales Orders Quantity';
                //     DecimalPlaces = 0 : 5;
                //     ApplicationArea = All;
                // }
                // field("RTMPSubcFeas2.""Reserved Quantity"""; RTMPSubcFeas2."Reserved Quantity")
                // {
                //     BlankZero = true;
                //     Caption = 'Reserved Quantity';
                //     DecimalPlaces = 0 : 5;
                //     ApplicationArea = All;
                // }

                //Campi nuovi presi da Plastiape

                field("Remaining Qty. (Base)"; Rec."Remaining Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Description = '';
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Visible = false;
                }
                field("Expected Qty. (Base)"; Rec."Expected Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Visible = false;
                }
                field("Internal Location"; Rec."Internal Location")
                {
                    ApplicationArea = All;
                }
                field("Internal Inventory"; Rec."Internal Inventory")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnDrillDown()
                    begin
                        if Rec."Internal Inventory" > 0 then
                            F_DrillDownInternalInventory();
                    end;
                }
                field("Int. Reserved Quantity (Base)"; Rec."Int. Reserved Quantity (Base)")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field("Int. Qty. used Other (Base)"; Rec."Int. Qty. used Other (Base)")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnDrillDown()
                    begin
                        if Rec."Int. Qty. used Other (Base)" > 0 then
                            F_DrillDownInternalQtyUsedByOther();
                    end;
                }

                //TODO i campi per il terzista renderli visibili solo quando l'ODP ha almeno una fase esterna
                field("External Location"; Rec."External Location")
                {
                    ApplicationArea = All;
                }
                field("External Inventory"; Rec."External Inventory")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    DecimalPlaces = 0 : 5;

                    trigger OnDrillDown()
                    begin
                        if Rec."External Inventory" > 0 then
                            F_DrillDownExternalInventory();
                    end;
                }
                field("Subc. Reserved Quantity (Base)"; Rec."Subc. Reserved Quantity (Base)")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                }
                field("Subc. Qty. used Other (Base)"; Rec."Subc. Qty. used Other (Base)")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnDrillDown()
                    begin
                        if Rec."Subc. Qty. used Other (Base)" > 0 then
                            F_DrillDownExternalQtyUsedByOther();
                    end;
                }

                field("Qty. in Transfer Order"; Rec."Qty. in Transfer Order")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;

                    trigger OnDrillDown()
                    begin
                        if Rec."Qty. in Transfer Order" > 0 then
                            F_DrillDownQtyInTransferOrder();
                    end;
                }
                field("Global Inventory"; Rec."Global Inventory")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifica la somma tra la giacenza interna ed esterna.'; //TODO fare in inglese
                }
                field("Internal Inventory Other Loc."; Rec."Internal Inventory Other Loc.")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifica la quantità interna presente in altre ubicazioni rispetto a quella specificata sulla riga.'; //TODO fare in inglese

                    trigger OnDrillDown()
                    begin
                        if Rec."Internal Inventory Other Loc." > 0 then
                            F_DrillDownInternalInventoryOtherLoc();
                    end;
                }
                field("Total Subc. Rem. Qty. (Base)"; Rec."Total Subc. Rem. Qty. (Base)")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    ToolTip = 'Specifica la somma della "quantità rimanente" di tutti i componenti uguali al componente presente sulla riga in tutti gli ordini di produzione RILASCIATI con ubicazione uguale a quella del terzista presente sulla riga.'; //TODO fare in inglese

                    trigger OnDrillDown()
                    begin
                        if Rec."Total Subc. Rem. Qty. (Base)" > 0 then
                            F_DrillDownTotalSubcRemQty();
                    end;
                }
                field("Qty. on Int. Component Lines"; Rec."Qty. on Int. Component Lines")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifica la somma della "quantità rimanente" di tutti i componenti uguali al componente presente sulla riga in tutti gli ordini di produzione RILASCIATI con la stessa ubicazione presente sulla riga.'; //TODO fare in inglese

                    trigger OnDrillDown()
                    begin
                        if Rec."Qty. on Int. Component Lines" > 0 then
                            F_DrillDownQtyOnIntComponentLines();
                    end;
                }
                field("Expected Receipt Qty. (Base)"; Rec."Expected Receipt Qty. (Base)")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    ToolTip = 'Specifies the total quantity expected to be received for the item from purchase, production, and assembly orders.';
                    //in italiano = 'Specifica la quantità totale prevista in entrata per l\'articolo da ordini di acquisto, produzione e assemblaggio.'

                    trigger OnDrillDown()
                    begin
                        if Rec."Expected Receipt Qty. (Base)" > 0 then
                            F_DrillDownExpectedReceiptQty();
                    end;
                }

                field("Not Feasible"; Rec."Not Feasible")
                {
                    ApplicationArea = All;
                }
                field("Partially Feasible"; Rec."Partially Feasible")
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
            action(ItemCard)
            {
                Caption = 'Item Card';
                Image = EditLines;
                RunObject = page "Item Card";
                RunPageLink = "No." = field("Item No.");
                RunPageMode = View;
                ApplicationArea = All;
            }
            action(Availability)
            {
                Caption = 'Availability';
                Image = Trace;
                ApplicationArea = All;

                trigger OnAction()
                var
                    L_CProduction: Codeunit "Production Codeunit FLE";
                begin
                    if Rec."Item No." <> '' then
                        L_CProduction.ShowItemAvailability(Rec."Item No.", '', '');
                end;
            }
            action(ViewNotFullyFeasibleComponents)
            {
                Caption = 'View Not Fully Feasible Components';
                ApplicationArea = All;
                Image = ViewDocumentLine;

                trigger OnAction()
                var
                    L_RTempSubcFeasibility1: Record "TMP Subc. Feasibility 1 PTE" temporary;
                    L_AllComponentFeasibleMsg: Label 'All components for production order %1 are fully feasible.';
                begin
                    L_RTempSubcFeasibility1.Copy(Rec, true);
                    L_RTempSubcFeasibility1.FilterGroup(-1);
                    L_RTempSubcFeasibility1.SetRange("Not Feasible", true);
                    L_RTempSubcFeasibility1.SetRange("Partially Feasible", true);
                    L_RTempSubcFeasibility1.FilterGroup(0);
                    If L_RTempSubcFeasibility1.IsEmpty then begin
                        Message(L_AllComponentFeasibleMsg, Rec."Prod. Order No.");
                        exit;
                    end;
                    if L_RTempSubcFeasibility1.FindSet() then
                        repeat
                            Rec.Get(L_RTempSubcFeasibility1.Status,
                                    L_RTempSubcFeasibility1."Prod. Order No.",
                                    L_RTempSubcFeasibility1."Prod. Order Line No.",
                                    L_RTempSubcFeasibility1."Line No.");
                            Rec.Mark(true);
                        until L_RTempSubcFeasibility1.Next() = 0;
                    Rec.MarkedOnly(true);
                end;
            }
            action(ViewAllComponents)
            {
                Caption = 'View All Components';
                ApplicationArea = All;
                Image = ReviewWorksheet;

                trigger OnAction()
                begin
                    Rec.MarkedOnly(false);
                    Rec.ClearMarks();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if not RTMPSubcFeas2.Get(Rec."Item No.", Rec."Variant Code") then
            Clear(RTMPSubcFeas2);

        if Rec."Quantity per" > 0 then
            CompFeas := Round(RTMPSubcFeas2."Available Quantity" / Rec."Quantity per", 1, '<')
        else
            CompFeas := 0;

        F_SetControls();
    end;

    var
        RTMPSubcFeas2: Record "TMP Subc. Feasibility 2 FLE" temporary;
        RTMPSubcFeas, RTMPSubcFeasSave : Record "TMP Subc. Feasibility PTE" temporary;
        ProdOrderNoForDrillDownInternalQtyUsedByOtherPerProdOrder, ProdOrderNoForDrillDownExternalQtyUsedByOtherPerProdOrder : Dictionary of [Text, Dictionary of [Code[30], Dictionary of [Code[10], Text]]];
        CompFeas: Decimal;
        ExternalLocation: Code[10];
        LocationFilter: Text;
        RecStyle: Text;

    procedure GetTmpRec(var V_RTMPSubcFeas: Record "TMP Subc. Feasibility PTE" temporary; var V_RTMPSubcFeas1: Record "TMP Subc. Feasibility 1 PTE"; var V_RTMPSubcFeas2: Record "TMP Subc. Feasibility 2 FLE")
    begin
        RTMPSubcFeas.Copy(V_RTMPSubcFeas, true);
        RTMPSubcFeas.Reset();
        if RTMPSubcFeas.FindSet() then
            repeat
                RTMPSubcFeasSave := RTMPSubcFeas;
                RTMPSubcFeasSave.Insert();
            until RTMPSubcFeas.Next() = 0;
        V_RTMPSubcFeas1.Copy(Rec, true);
        RTMPSubcFeas2.Copy(V_RTMPSubcFeas2, true);
        exit;
    end;

    procedure GetProdOrderDictionary(var V_ProdOrderNoForDrillDownInternalQtyUsedByOtherPerProdOrder: Dictionary of [Text, Dictionary of [Code[30], Dictionary of [Code[10], Text]]]; var V_ProdOrderNoForDrillDownExternalQtyUsedByOtherPerProdOrder: Dictionary of [Text, Dictionary of [Code[30], Dictionary of [Code[10], Text]]])
    begin
        ProdOrderNoForDrillDownInternalQtyUsedByOtherPerProdOrder := V_ProdOrderNoForDrillDownInternalQtyUsedByOtherPerProdOrder;
        ProdOrderNoForDrillDownExternalQtyUsedByOtherPerProdOrder := V_ProdOrderNoForDrillDownExternalQtyUsedByOtherPerProdOrder;
    end;

    procedure SetLocationFilter(P_LocationFilter: Text)
    begin
        LocationFilter := P_LocationFilter;
    end;

    local procedure F_SetControls()
    begin
        case true of
            Rec."Not Feasible":
                RecStyle := 'Attention';
            Rec."Partially Feasible":
                RecStyle := 'AttentionAccent';
            else
                RecStyle := '';
        end;
    end;

    //DUPLICATED c'è anche in page "FLEXSubcontactorFeasibilityPTE"
    local procedure F_GetProdOrderFilterFromDictionaryForQty(P_ProdOrderNoForDrillDownQtyUsedByOtherPerProdOrder: Dictionary of [Text, Dictionary of [Code[30], Dictionary of [Code[10], Text]]]; var V_ProdNoFilter: Text; P_ProdOrerNo: Code[20]; P_ProdOrderLineNo: Integer; P_ItemNo: Code[20]; P_VariantCode: Code[10]; P_LocationCode: Code[10]): Boolean
    var
        L_ProdOrderDictionaryKey: Text;
        L_ItemVariantDictionaryKey: Code[30];
        L_ComponentsDictionary: Dictionary of [Code[30], Dictionary of [Code[10], Text]];
        L_LocationDictionary: Dictionary of [Code[10], Text];
    begin
        V_ProdNoFilter := '';
        L_ProdOrderDictionaryKey := P_ProdOrerNo + Format(P_ProdOrderLineNo);
        L_ItemVariantDictionaryKey := P_ItemNo + P_VariantCode;
        if not P_ProdOrderNoForDrillDownQtyUsedByOtherPerProdOrder.Get(L_ProdOrderDictionaryKey, L_ComponentsDictionary) then
            exit(false);
        if not L_ComponentsDictionary.Get(L_ItemVariantDictionaryKey, L_LocationDictionary) then
            exit(false);
        if not L_LocationDictionary.Get(P_LocationCode, V_ProdNoFilter) then
            exit(false);
        exit(true);
    end;

    #region Funzioni DrillDown
    local procedure F_DrillDownInternalInventory()
    begin
        F_DrillDownInventory(Rec."Internal Location",
                             '',
                             Rec."Item No.",
                             Rec."Variant Code",
                             0);
    end;

    local procedure F_DrillDownExternalInventory()
    begin
        F_DrillDownInventory(Rec."Internal Location",
                             Rec."External Location",
                             Rec."Item No.",
                             Rec."Variant Code",
                             1);
    end;

    local procedure F_DrillDownInventory(P_InternalLocation: Code[10]; P_ExternalLocation: Code[10]; P_ItemNo: Code[20]; P_VariantCode: Code[10]; P_InventoryType: Option Int,Ext)
    var
        L_RItemLedgerEntry: Record "Item Ledger Entry";
        L_RTempItemLedgerEntry: Record "Item Ledger Entry" temporary;
        L_RTransferLine: Record "Transfer Line";
        L_NotPostedLbl: Label 'Order to post';
    begin
        F_FilterTransferLine(L_RTransferLine, P_InternalLocation, P_ExternalLocation, P_ItemNo, P_VariantCode);
        L_RItemLedgerEntry.FilterGroup(20);
        L_RItemLedgerEntry.SetRange("Item No.", P_ItemNo);
        L_RItemLedgerEntry.SetRange("Variant Code", P_VariantCode);
        case P_InventoryType of
            P_InventoryType::Int:
                L_RItemLedgerEntry.SetRange("Location Code", P_InternalLocation);
            P_InventoryType::Ext:
                L_RItemLedgerEntry.SetRange("Location Code", P_ExternalLocation);
        end;
        L_RItemLedgerEntry.FilterGroup(0);
        if L_RTransferLine.IsEmpty then
            Page.Run(0, L_RItemLedgerEntry)
        else begin
            L_RItemLedgerEntry.SetCurrentKey("Entry No.");
            if L_RItemLedgerEntry.FindSet() then
                repeat
                    L_RTempItemLedgerEntry := L_RItemLedgerEntry;
                    L_RTempItemLedgerEntry.Insert(false);
                until L_RItemLedgerEntry.Next() = 0;
            if L_RTransferLine.FindSet() then
                repeat
                    L_RTempItemLedgerEntry.Init();
                    L_RTempItemLedgerEntry."Entry No." += 1;
                    L_RTempItemLedgerEntry."Entry Type" := L_RTempItemLedgerEntry."Entry Type"::Transfer;
                    case P_InventoryType of
                        P_InventoryType::Int:
                            begin
                                L_RTempItemLedgerEntry."Document Type" := L_RTempItemLedgerEntry."Document Type"::"Transfer Shipment";
                                L_RTempItemLedgerEntry.Quantity := -L_RTransferLine.Quantity;
                                L_RTempItemLedgerEntry."Location Code" := L_RTransferLine."Transfer-from Code";
                            end;
                        P_InventoryType::Ext:
                            begin
                                L_RTempItemLedgerEntry."Document Type" := L_RTempItemLedgerEntry."Document Type"::"Transfer Receipt";
                                L_RTempItemLedgerEntry.Quantity := L_RTransferLine.Quantity;
                                L_RTempItemLedgerEntry."Location Code" := L_RTransferLine."Transfer-to Code";
                            end;
                    end;
                    L_RTempItemLedgerEntry."Document No." := CopyStr(L_NotPostedLbl, 1, MaxStrLen(L_RTempItemLedgerEntry."Document No."));
                    L_RTempItemLedgerEntry."Item No." := L_RTransferLine."Item No.";
                    L_RTempItemLedgerEntry."Variant Code" := L_RTransferLine."Variant Code";
                    L_RTempItemLedgerEntry."Qty. per Unit of Measure" := L_RTransferLine."Qty. per Unit of Measure";
                    L_RTempItemLedgerEntry."Remaining Quantity" := 0;
                    L_RTempItemLedgerEntry."Order Type" := L_RTempItemLedgerEntry."Order Type"::Transfer;
                    L_RTempItemLedgerEntry."Order No." := L_RTransferLine."Document No.";
                    L_RTempItemLedgerEntry."Order Line No." := L_RTransferLine."Line No.";
                    L_RTempItemLedgerEntry.Insert(false);
                until L_RTransferLine.Next() = 0;
            L_RTempItemLedgerEntry.SetCurrentKey("Entry No.");
            //Utilizzo la page per visualizzare la Preview in quanto è stata pensata per avere all'interno record temporanei
            //Inoltre non ci sono azioni a video che potrebbero causare danni
            Page.Run(Page::"Item Ledger Entries Preview", L_RTempItemLedgerEntry);
        end;
    end;

    //TODO nome da cambiare quando e se cambierò il nome del campo
    local procedure F_DrillDownInternalQtyUsedByOther()
    var
        L_FSubcontactorFeasibility2: Page "Subcontactor Feasibility 2 PTE";
        L_RTempSubcFeasibility1: Record "TMP Subc. Feasibility 1 PTE" temporary;
        L_RTempSubcFeasibility1_2: Record "TMP Subc. Feasibility 1 PTE" temporary;
        L_RTempSubcFeasibility: Record "TMP Subc. Feasibility PTE" temporary;
        L_ComponentsDictionary: Dictionary of [Code[30], Dictionary of [Code[10], Text]];
        L_LocationDictionary: Dictionary of [Code[10], Text];
        L_ProdOrderNo: Code[20];
        L_ProdOrderDictionaryKey: Text;
        L_ItemVariantDictionaryKey: Code[30];
        L_RProductionOrder: Record "Production Order";
        L_RProdOrderComponent: Record "Prod. Order Component";
        L_ProdOrderFilter: Text;
    begin
        F_GetProdOrderFilterFromDictionaryForQty(ProdOrderNoForDrillDownInternalQtyUsedByOtherPerProdOrder,
                                                 L_ProdOrderFilter,
                                                 Rec."Prod. Order No.",
                                                 Rec."Prod. Order Line No.",
                                                 Rec."Item No.",
                                                 Rec."Variant Code",
                                                 Rec."Internal Location");
        L_RProdOrderComponent.FilterGroup(20);
        L_RProdOrderComponent.SetFilter("Prod. Order No.", L_ProdOrderFilter);
        L_RProdOrderComponent.SetRange("Item No.", Rec."Item No.");
        L_RProdOrderComponent.SetRange("Variant Code", Rec."Variant Code");
        L_RProdOrderComponent.FilterGroup(0);
        Page.Run(0, L_RProdOrderComponent);
    end;

    //TODO nome da cambiare quando e se cambierò il nome del campo
    local procedure F_DrillDownExternalQtyUsedByOther()
    var
        L_FSubcontactorFeasibility2: Page "Subcontactor Feasibility 2 PTE";
        L_RTempSubcFeasibility1: Record "TMP Subc. Feasibility 1 PTE" temporary;
        L_RTempSubcFeasibility1_2: Record "TMP Subc. Feasibility 1 PTE" temporary;
        L_RTempSubcFeasibility: Record "TMP Subc. Feasibility PTE" temporary;
        L_ComponentsDictionary: Dictionary of [Code[30], Dictionary of [Code[10], Text]];
        L_LocationDictionary: Dictionary of [Code[10], Text];
        L_ProdOrderNo: Code[20];
        L_ProdOrderDictionaryKey: Text;
        L_ItemVariantDictionaryKey: Code[30];
        L_RProductionOrder: Record "Production Order";
        L_RProdOrderComponent: Record "Prod. Order Component";
        L_ProdOrderFilter: Text;
    begin
        F_GetProdOrderFilterFromDictionaryForQty(ProdOrderNoForDrillDownExternalQtyUsedByOtherPerProdOrder,
                                                 L_ProdOrderFilter,
                                                 Rec."Prod. Order No.",
                                                 Rec."Prod. Order Line No.",
                                                 Rec."Item No.",
                                                 Rec."Variant Code",
                                                 Rec."External Location");
        L_RProdOrderComponent.FilterGroup(20);
        L_RProdOrderComponent.SetFilter("Prod. Order No.", L_ProdOrderFilter);
        L_RProdOrderComponent.SetRange("Item No.", Rec."Item No.");
        L_RProdOrderComponent.SetRange("Variant Code", Rec."Variant Code");
        L_RProdOrderComponent.FilterGroup(0);
        Page.Run(0, L_RProdOrderComponent);
    end;

    local procedure F_DrillDownInternalInventoryOtherLoc()
    var
        L_RItemLedgerEntry: Record "Item Ledger Entry";
    begin
        L_RItemLedgerEntry.FilterGroup(20);
        L_RItemLedgerEntry.SetRange("Item No.", Rec."Item No.");
        L_RItemLedgerEntry.SetRange("Variant Code", Rec."Variant Code");
        L_RItemLedgerEntry.SetFilter("Location Code", LocationFilter);
        L_RItemLedgerEntry.FilterGroup(21);
        L_RItemLedgerEntry.SetFilter("Location Code", '<>%1', Rec."Internal Location");
        L_RItemLedgerEntry.FilterGroup(0);
        Page.Run(0, L_RItemLedgerEntry);
    end;

    local procedure F_DrillDownTotalSubcRemQty()
    var
        L_RProdOrderComponent: Record "Prod. Order Component";
    begin
        L_RProdOrderComponent.FilterGroup(20);
        L_RProdOrderComponent.SETRANGE("Item No.", Rec."Item No.");
        L_RProdOrderComponent.SETRANGE("Variant Code", Rec."Variant Code");
        L_RProdOrderComponent.SETRANGE("Location Code", Rec."External Location");
        L_RProdOrderComponent.SETRANGE(Status, L_RProdOrderComponent.Status::Released);
        L_RProdOrderComponent.FilterGroup(0);
        Page.Run(0, L_RProdOrderComponent);
    end;

    local procedure F_DrillDownQtyOnIntComponentLines()
    var
        L_RProdOrderComponent: Record "Prod. Order Component";
    begin
        L_RProdOrderComponent.FilterGroup(20);
        L_RProdOrderComponent.SETRANGE("Item No.", Rec."Item No.");
        L_RProdOrderComponent.SETRANGE("Variant Code", Rec."Variant Code");
        L_RProdOrderComponent.SETRANGE("Location Code", Rec."Internal Location");
        L_RProdOrderComponent.SETRANGE(Status, L_RProdOrderComponent.Status::Released);
        L_RProdOrderComponent.FilterGroup(0);
        Page.Run(0, L_RProdOrderComponent);
    end;

    local procedure F_DrillDownQtyInTransferOrder()
    var
        L_RTransferLine: Record "Transfer Line";
    begin
        L_RTransferLine.FilterGroup(20);
        F_FilterTransferLine(L_RTransferLine,
                             Rec."Internal Location",
                             Rec."External Location",
                             Rec."Item No.",
                             Rec."Variant Code");
        L_RTransferLine.FilterGroup(0);
        Page.Run(0, L_RTransferLine);
    end;

    local procedure F_DrillDownExpectedReceiptQty()
    var
        L_RProdOrderLine: Record "Prod. Order Line";
        L_RPurchaseLine: Record "Purchase Line";
        L_RAssemblyHeader: Record "Assembly Header";
        L_FSubcontactorFeasibility: Page "Subcontactor Feasibility PTE";
    begin
        //Ordini di produzione
        L_FSubcontactorFeasibility.FilterProdOrderLineForExpectedReceiptQty(L_RProdOrderLine, Rec."Item No.", Rec."Variant Code", Rec."Internal Location");
        if not L_RProdOrderLine.IsEmpty() then
            page.Run(Page::"Prod. Order Line List", L_RProdOrderLine);


        //Ordini di acquisto
        L_FSubcontactorFeasibility.FilterPurchaseLineForExpectedReceiptQty(L_RPurchaseLine, Rec."Item No.", Rec."Variant Code", Rec."Internal Location");
        if not L_RPurchaseLine.IsEmpty() then
            page.Run(Page::"Purchase Lines", L_RPurchaseLine);

        //Ordini di assemblaggio
        L_FSubcontactorFeasibility.FilterProdOrderLineForExpectedReceiptQty(L_RAssemblyHeader, Rec."Item No.", Rec."Variant Code", Rec."Internal Location");
        if not L_RAssemblyHeader.IsEmpty() then
            Page.Run(Page::"Assembly List", L_RAssemblyHeader);
    end;
    #endregion

    local procedure F_FilterTransferLine(var V_RTransferLine: Record "Transfer Line"; P_FromLocationCode: Code[10]; P_ToLocationCode: Code[10]; P_ItemNo: Code[20]; P_VariantCode: Code[10])
    begin
        if P_FromLocationCode <> '' then
            V_RTransferLine.SETRANGE("Transfer-from Code", P_FromLocationCode);
        if P_ToLocationCode <> '' then
            V_RTransferLine.SETRANGE("Transfer-to Code", P_ToLocationCode);
        V_RTransferLine.SETRANGE("Item No.", P_ItemNo);
        V_RTransferLine.SETRANGE("Variant Code", P_VariantCode);
    end;

    procedure GetRecComponent(var V_ItemNo: Code[20]; var V_VariantCode: Code[10])
    begin
        V_ItemNo := Rec."Item No.";
        V_VariantCode := Rec."Variant Code";
    end;

    procedure GetRecLocation(var V_InternalLocation: Code[10]; var V_ExternalLocation: Code[10])
    begin
        V_InternalLocation := Rec."Internal Location";
        V_ExternalLocation := Rec."External Location";
    end;

    procedure SetFilterOnComponent(P_ItemNoFilter: Text; P_VariantCodeFilter: Text)
    begin
        Rec.FilterGroup(20);
        if P_ItemNoFilter = '' then
            Rec.SetRange("Item No.")
        else
            Rec.SetFilter("Item No.", P_ItemNoFilter);

        if P_VariantCodeFilter = '' then
            Rec.SetRange("Variant Code")
        else
            Rec.SetFilter("Variant Code", P_VariantCodeFilter);
        Rec.FilterGroup(0);
    end;
}