page 50110 "Subcontactor Feasibility PTE"
{

    //TODO Utilizzare CConfirmManagement al posto dei vari confirm

    // TODO: Implementare azione  QtyUpdateDate Modifica Quantità e Data
    //          (azione resa per ora Visible FALSE)
    // 
    //          Considerare anche articoli WIP

    Caption = 'Subcontactor Global Feasibility';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPlus;
    // SaveValues = true;
    SourceTable = "TMP Subc. Feasibility PTE";
    SourceTableTemporary = true;
    SourceTableView = sorting("Status Order", "Due Date", "Prod. Order No.", "Line No.") order(ascending);
    UsageCategory = Tasks;
    ApplicationArea = All;

    //TODO Fabio ha chiesto di fare una funzionalità dove per i fornitori gestiti a progetto, che quindi hanno sotto altri fornitori tipo Newmont
    // far si che loro vedano solo i fornitori figli e che quindi il calcolo della giacenza sia fatta solo su quelli.
    // e non possano vedere le altre giacenze e neanche tutte le azioni.

    layout
    {
        area(Content)
        {
            group(FiltersGroup)
            {
                Caption = 'Filters';
                grid(Grid0000001)
                {
                    ShowCaption = false;
                    group(ProdOrdersFiltersGroup)
                    {
                        Caption = 'Production Orders';
                        grid(Grid0000002)
                        {
                            ShowCaption = false;
                            field(SubcontractorNoFilter; SubcontractorNoFilter)
                            {
                                Caption = 'Subcontractor No.';

                                trigger OnValidate()
                                begin
                                    F_SetFilters();
                                    CurrPage.Update(false);
                                end;

                                trigger OnLookup(var Text: Text): Boolean
                                begin
                                    exit(F_LookupSubcontractorNo(Text));
                                end;
                            }
                            field(ItemNoFilter; ItemNoFilter)
                            {
                                Caption = 'Item No.';

                                trigger OnValidate()
                                begin
                                    F_SetFilters();
                                    CurrPage.Update(false);
                                end;

                                trigger OnLookup(var Text: Text): Boolean
                                begin
                                    exit(F_LookupItemNo(Text));
                                end;
                            }
                            field(StandardTaskCodeFilter; StandardTaskCodeFilter)
                            {
                                Caption = 'Standard Task Code';

                                trigger OnValidate()
                                begin
                                    F_SetFilters();
                                    CurrPage.Update(false);
                                end;

                                trigger OnLookup(var Text: Text): Boolean
                                begin
                                    exit(F_LookupStandardTaskCode(Text));
                                end;
                            }
                        }
                        grid(Grid0000003)
                        {
                            field(DueDateToFilter; DueDateToFilter)
                            {
                                Caption = 'Up To Due Date';

                                trigger OnValidate()
                                begin
                                    CurrPage.Update(false);
                                end;
                            }
                            field(IncludeFirmPlanned; BIncludeFirmPlanned)
                            {
                                Caption = 'Firm Planned Orders Included';
                                ToolTip = 'Specifies whether firm planned production orders are included in the feasibility calculation.';

                                trigger OnValidate()
                                begin
                                    F_ReloadPageToApplyOption();
                                end;
                            }
                            field(BCalcReservationBasedOnMaxFeasibleQty; BCalcReservationBasedOnMaxFeasibleQty)
                            {
                                Caption = 'Limit Reservation by Min. Comp. Avail.';
                                //!In italiano 'Limita impegno per disp. minima comp.'
                                ToolTip = 'Specifies whether component reservation is limited by the lowest feasible quantity in the production order, instead of reserving the maximum possible quantity.';
                                //! in italiano 'Specifica se l’impegno dei componenti viene calcolato in base alla quantità fattibile più bassa tra i componenti dell'ordine di produzione, anziché impegnare la quantità massima possibile.'

                                trigger OnValidate()
                                begin
                                    F_ReloadPageToApplyOption();
                                end;
                            }
                        }
                    }
                    group(ComponentsFiltersGroup)
                    {
                        Caption = 'Components';
                        grid(Grid0000004)
                        {
                            ShowCaption = false;
                            field(ItemNoComponentFilter; ItemNoComponentFilter)
                            {
                                Caption = 'Item No.';

                                trigger OnValidate()
                                var
                                    L_RItemVariant: Record "Item Variant";
                                    L_RItem: Record Item;
                                begin
                                    IsComponentFilterSet := ItemNoComponentFilter <> '';
                                    VariantCodeComponentFilter := '';
                                    if not IsComponentFilterSet then begin
                                        BEnableComponentVariantCodeFilter := false;
                                        exit;
                                    end;
                                    L_RItem.Get(ItemNoComponentFilter);
                                    L_RItemVariant.SetRange("Item No.", ItemNoComponentFilter);
                                    BEnableComponentVariantCodeFilter := not L_RItemVariant.IsEmpty;
                                end;

                                trigger OnLookup(var Text: Text): Boolean
                                begin
                                    exit(F_LookupComponentItemNo(Text));
                                end;
                            }
                            field(VariantCodeComponentFilter; VariantCodeComponentFilter)
                            {
                                Caption = 'Variant Code';
                                Enabled = BEnableComponentVariantCodeFilter;
                                Editable = BEnableComponentVariantCodeFilter;

                                trigger OnValidate()
                                var
                                    L_RItemVariant: Record "Item Variant";
                                begin
                                    if VariantCodeComponentFilter <> '' then
                                        L_RItemVariant.Get(ItemNoComponentFilter, VariantCodeComponentFilter);
                                end;

                                trigger OnLookup(var Text: Text): Boolean
                                begin
                                    exit(F_LookupVariantCode(Text, ItemNoComponentFilter));
                                end;
                            }
                        }
                    }
                }
            }
            repeater(FieldList)
            {
                IndentationColumn = Rec."Line No."; //Proprietà definita solo per impedire l'ordinamento

                field(Status; Rec.Status)
                {
                    Editable = false;
                    StyleExpr = RecStyle;
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    Editable = false;
                    AssistEdit = false;
                    DrillDown = false;
                    Lookup = false;
                    StyleExpr = RecStyle;
                }
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                    AssistEdit = false;
                    DrillDown = false;
                    Lookup = false;
                    StyleExpr = RecStyle;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Editable = false;
                    Visible = false;
                    StyleExpr = RecStyle;
                }
                field("Item Description"; Rec."Item Description")
                {
                    Editable = false;
                    StyleExpr = RecStyle;
                }
                field(Subcontractor; Rec.Subcontractor)
                {
                    Editable = false;
                    AssistEdit = false;
                    DrillDown = false;
                    Lookup = false;
                    // StyleExpr = RecStyle;
                }
                field("Subcontractor Name"; Rec."Subcontractor Name")
                {
                    Editable = false;
                    // StyleExpr = RecStyle;
                }
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                    Visible = false;
                    // StyleExpr = RecStyle;
                }
                field("Planning Group"; Rec."Planning Group")
                {
                    Editable = false;
                    Visible = false;
                    // StyleExpr = RecStyle;
                }
                field("Due Date"; Rec."Due Date")
                {
                    // StyleExpr = RecStyle;
                    trigger OnValidate()
                    var
                        L_RProductionOrder: Record "Production Order";
                        L_ProdOrderNotExistErr: Label 'Unable to proceed with the modification of the due date. Production order %1 %2 does not exist.';
                        // L_ProdOrderDueDateChangeConfirm: Label 'Do you confirm the change of the due date from %1 to %2?', Comment = '%1 = Data di scadenza originale, %2 = Nuova data di scadenza inserita';
                        L_ReloadToDueDateChangesConfirm: Label 'The page must be reloaded to recalculate the feasibility of production orders. Alternatively, you can do this later, but component inventory commitments may be inaccurate and most of the page''s functionality will be disabled. Do you want to continue?';
                    //! In italiano: È necessario ricaricare la pagina per ricalcolare la fattibilità degli ordini di produzione. In alternativa, puoi farlo in un secondo momento, ma gli impegni sulle giacenze dei componenti potrebbero non essere corretti e la maggior parte delle funzionalità della pagina saranno disattivate. Vuoi continuare?

                    begin
                        if xRec."Due Date" = Rec."Due Date" then
                            exit;
                        if not L_RProductionOrder.Get(Rec.Status, Rec."Prod. Order No.") then
                            Error(L_ProdOrderNotExistErr, Rec.Status, Rec."Prod. Order No.");

                        // if not CConfirmManagement.GetResponseOrDefault(StrSubstNo(L_ProdOrderDueDateChangeConfirm, xRec."Due Date", Rec."Due Date"), true) then begin
                        //     Rec."Due Date" := xRec."Due Date";
                        //     exit;
                        // end;

                        L_RProductionOrder.SetUpdateEndDate();
                        L_RProductionOrder.Validate("Due Date", Rec."Due Date");
                        L_RProductionOrder.Modify(true);

                        if CConfirmManagement.GetResponseOrDefault(L_ReloadToDueDateChangesConfirm, false) then
                            F_LoadData()
                        else
                            F_DisableActionAndDrillDownAtDueDateChange();
                        CurrPage.Update(false);
                    end;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    Editable = false;
                    // StyleExpr = RecStyle;
                }
                field("Starting Time"; Rec."Starting Time")
                {
                    Editable = false;
                    visible = false;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    Editable = false;
                    // StyleExpr = RecStyle;
                }
                field("Ending Time"; Rec."Starting Time")
                {
                    Editable = false;
                    visible = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Editable = false;
                    AssistEdit = false;
                    DrillDown = false;
                    Lookup = false;
                    Visible = false;
                    // StyleExpr = RecStyle;
                }
                field("Quantity (Base)"; Rec."Operation Quantity (Base)")
                {
                    Editable = false;
                    BlankZero = true;
                    // StyleExpr = RecStyle;
                }
                field("Remaining Qty. (Base)"; Rec."Operation Rem. Qty. (Base)")
                {
                    Editable = false;
                    BlankZero = true;
                    // StyleExpr = RecStyle;
                }
                field("Finished Qty. (Base)"; Rec."Operation Finished Qty. (Base)")
                {
                    Editable = false;
                    BlankZero = true;
                    // StyleExpr = RecStyle;
                }
                field("Int. Feasible Quantity (Base)"; Rec."Int. Feasible Quantity (Base)")
                {
                    Editable = false;
                    BlankZero = true;
                    // StyleExpr = RecStyle;
                }
                field("Subc. Feasible Quantity (Base)"; Rec."Subc. Feasible Quantity (Base)")
                {
                    Editable = false;
                    BlankZero = true;
                    // StyleExpr = RecStyle;
                }
                field("TS Feasible Quantity (Base)"; Rec."TS Feasible Quantity (Base)")
                {
                    Editable = false;
                    BlankZero = true;
                    // StyleExpr = RecStyle;
                }
                field("Subcontractor Order"; Rec."Subcontractor Order")
                {
                    Editable = false;
                    // StyleExpr = RecStyle;
                }
                field("Full Feasible"; Rec."Full Feasible")
                {
                    Editable = false;
                    // StyleExpr = RecStyle;
                }
                field("Full Feasible SubC"; Rec."Full Feasible SubC")
                {
                    Editable = false;
                    // StyleExpr = RecStyle;
                }
                field("Full Feasible Transfer"; Rec."Full Feasible Transfer")
                {
                    Editable = false;
                    // StyleExpr = RecStyle;
                }
                field("Partially Feasible"; Rec."Partially Feasible")
                {
                    Editable = false;
                    // StyleExpr = RecStyle;
                }
            }
            group(Components)
            {
                Caption = 'Prod. Order Components';
                part(ComponentsPart; "Subcontactor Feasibility 1 PTE")
                {
                    Caption = ' ', Locked = true;
                    SubPageLink = Status = field(Status),
                                  "Prod. Order No." = field("Prod. Order No."),
                                  "Prod. Order Line No." = field("Line No.");
                    UpdatePropagation = Both;
                }
            }
            group(ComponentOrders)
            {
                Caption = 'Prod. Orders With Component'; //ITA = "Ordini di prod. con componente"
                part(ConflictPart; "Subcontactor Feasibility 2 PTE")
                {
                    Caption = ' ', Locked = true;
                    Provider = ComponentsPart;
                    SubPageLink = "Item No." = field("Item No."),
                                  "Variant Code" = field("Variant Code");
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(LoadData)
            {
                Caption = 'Load';
                Ellipsis = true;
                Image = Start;
                ShortcutKey = 'Ctrl+F7';

                trigger OnAction()
                var
                    L_LoadPageConfirm: label 'Load the page?';
                begin
                    if not CConfirmManagement.GetResponseOrDefault(L_LoadPageConfirm, false) then
                        exit;
                    F_LoadData();
                end;
            }
            group(Filters)
            {
                Caption = 'Filters';
                // action(ShowComplete)
                // {
                //     Caption = 'Show Completed';
                //     Enabled = not ShowComplete_S;
                //     Image = ClearFilter;
                //     Visible = not ShowComplete_S;

                //     trigger OnAction()
                //     begin
                //         ShowComplete_S := true;
                //         F_SetFilters();
                //         CurrPage.Update();
                //     end;
                // }
                // action(HideComplete)
                // {
                //     Caption = 'Hide Completed';
                //     Enabled = ShowComplete_S;
                //     Image = UseFilters;
                //     Visible = ShowComplete_S;

                //     trigger OnAction()
                //     begin
                //         ShowComplete_S := false;
                //         F_SetFilters();
                //         CurrPage.Update();
                //     end;
                // }
                action(AllOrders)
                {
                    Caption = 'All Orders';
                    Enabled = BFeasibleOnly and BFeasibleFilterEnabled;
                    Visible = BFeasibleOnly;
                    Image = OrderList;

                    trigger OnAction()
                    begin
                        BFeasibleOnly := false;
                        F_SetFilters();
                        CurrPage.Update();
                    end;
                }
                action(OnlyFeasibleOrders)
                {
                    Caption = 'Only Feasible Orders';
                    Enabled = not BFeasibleOnly and BFeasibleFilterEnabled;
                    Visible = not BFeasibleOnly;
                    Image = RegisterPick;

                    trigger OnAction()
                    begin
                        BFeasibleOnly := true;
                        F_SetFilters();
                        CurrPage.Update();
                    end;
                }
                group(InventoryComponentsFilters)
                {
                    Caption = 'Components Filters';
                    action(FilterProdOrdersForComponentUsingInternalInventory)
                    {
                        ApplicationArea = All;
                        Caption = 'Filter Prod. Ord. For Component Using Internal Inventory';
                        Image = FilterLines;
                        Enabled = BInternalInventoryComponentsFilterEnabled;
                        visible = (not BComponentUsingInventoryFilterApplied);
                        ToolTip = 'Allows you to identify the production orders that use the internal inventory related to the currently selected component.';
                        //! Tooltip in italiano: Consente di individuare gli ordini di produzione che impiegano la giacenza interna relativa al componente attualmente selezionato.

                        trigger OnAction()
                        var
                            L_NoProdThatReserveInventory: Label 'For the selected component there are no production orders that reserve internal inventory.';
                        begin
                            if not F_FilterProdOrdersForComponentUsingInventory(ProdOrderNoForDrillDownInternalQtyUsedByOtherPerProdOrder, 0) then begin //0: Internal
                                Message(L_NoProdThatReserveInventory);
                                exit;
                            end;
                            BComponentUsingInventoryFilterApplied := true;
                        end;
                    }
                    action(FilterProdOrdersForComponentUsingExternalInventory)
                    {
                        ApplicationArea = All;
                        Caption = 'Filter Prod. Ord. For Component Using External Inventory';
                        Enabled = BExternalInventoryComponentsFilterEnabled;
                        Image = FilterLines;
                        Visible = (not BComponentUsingInventoryFilterApplied);
                        ToolTip = 'Allows you to identify the production orders that use the external inventory related to the currently selected component.';
                        //! Tooltip in italiano: Consente di individuare gli ordini di produzione che impiegano la giacenza esterna relativa al componente attualmente selezionato.

                        trigger OnAction()
                        var
                            L_NoProdThatReserveInventory: Label 'For the selected component there are no production orders that reserve external inventory.';
                        begin
                            if not F_FilterProdOrdersForComponentUsingInventory(ProdOrderNoForDrillDownExternalQtyUsedByOtherPerProdOrder, 1) then begin //1: External
                                Message(L_NoProdThatReserveInventory);
                                exit;
                            end;
                            BComponentUsingInventoryFilterApplied := true;
                        end;
                    }
                    action(RemoveFilterOnProdOrderComponent)
                    {
                        ApplicationArea = All;
                        Caption = 'Remove Filter on Prod. Ord. Component';
                        Image = ClearFilter;
                        Visible = BComponentUsingInventoryFilterApplied;
                        ToolTip = 'Removes the filters currently applied that limit the view to production orders using the internal or external inventory of the selected component, in order to display all production orders.';
                        //! Tooltip in italiano: Rimuove i filtri attualmente applicati che limitano la visualizzazione agli ordini di produzione che utilizzano la giacenza interna o esterna del componente selezionato, in modo da mostrare tutti gli ordini di produzione.

                        trigger OnAction()
                        begin
                            Rec.FilterGroup(20);
                            Rec.SetRange("Prod. Order No.");
                            Rec.FilterGroup(0);
                            if not IsComponentFilterSet then
                                CurrPage.ComponentsPart.Page.SetFilterOnComponent('', '');
                            BComponentUsingInventoryFilterApplied := false;
                        end;
                    }
                }
            }
            group(TransferOrders)
            {
                Caption = 'Transfer Orders';
                action(CreateTransferOrderForSelectedComponents)
                {
                    ApplicationArea = All;
                    Caption = 'Create Transfer Order For Selected Components';
                    ToolTip = 'It allows you to create a transfer order from the internal location to the subcontractor''s location for selected components.';
                    Image = NewTransferOrder;
                    Enabled = BTransferOrderActionEnabled;

                    trigger OnAction()
                    var
                        L_RTempSubcFeasibility1: Record "TMP Subc. Feasibility 1 PTE" temporary;
                    begin
                        F_CheckThatProdOrderIsExternal(Rec);
                        L_RTempSubcFeasibility1.Copy(TempRSubcFeas1, true);
                        CurrPage.ComponentsPart.Page.SetSelectionFilter(L_RTempSubcFeasibility1);
                        F_CreateTransferOrder(L_RTempSubcFeasibility1);
                    end;
                }
                action(CreateTransferOrderForMissingComponents)
                {
                    ApplicationArea = All;
                    Caption = 'Create Transfer Order for Missing Components';
                    ToolTip = 'It allows you to create a transfer order from the internal location to the subcontractor''s location for components with external stock that is insufficient to cover the remaining quantity.';
                    Image = NewTransferOrder;
                    Enabled = BTransferOrderActionEnabled;

                    trigger OnAction()
                    var
                        L_RTempSubcFeasibility1: Record "TMP Subc. Feasibility 1 PTE" temporary;
                    begin
                        F_CheckThatProdOrderIsExternal(Rec);
                        L_RTempSubcFeasibility1.Copy(TempRSubcFeas1, true);
                        L_RTempSubcFeasibility1.Reset();
                        L_RTempSubcFeasibility1.SetRange(Status, Rec.Status);
                        L_RTempSubcFeasibility1.SetRange("Prod. Order No.", Rec."Prod. Order No.");
                        L_RTempSubcFeasibility1.SetRange("Prod. Order Line No.", Rec."Line No.");
                        L_RTempSubcFeasibility1.SetFilter("External Location", '<>%1', '');
                        L_RTempSubcFeasibility1.SetFilter("Int. Reserved Quantity (Base)", '>%1', 0);
                        F_CreateTransferOrder(L_RTempSubcFeasibility1);
                    end;
                }
            }
            action(QtyUpdateDate)
            {
                Caption = 'Change Quantity and Date';
                Image = EditLines;
                Visible = false;
                Enabled = false;

                trigger OnAction()
                var
                    TempL_RFLEXWrkf: Record "Manufacturing Work File FLE" temporary;
                    L_RProdOrdComp: Record "Prod. Order Component";
                    L_RProdOrdL: Record "Prod. Order Line";
                    L_RPurchL: Record "Purchase Line";
                    L_PGGenericDataInput: Page "Generic Data Input MFLE";
                    L_Error: Boolean;
                    L_Exit: Boolean;
                    L_VisEdt: array[28, 2] of Boolean;
                    L_Text001: Label 'Change Production Order Quantity';
                    L_Text002: Label 'Order qty cannot be less then %1', Comment = '%1=qty';
                    L_Text003: Label 'Subcontractor Order %1 updated', Comment = '%1=code';
                    L_Text004: Label 'Order End Date cannot be empty';
                    L_Text005: Label 'Order End Date cannot be previuos then today';
                    L_FieldCaption: array[28] of Text[30];
                    L_WinTitle: Text[50];
                    L_Instructions: Text[100];
                begin
                    Error('Funzione Non Implementata');

                    L_RProdOrdL.Get(Rec.Status, Rec."Prod. Order No.", Rec."Line No.");
                    Clear(L_PGGenericDataInput);
                    TempL_RFLEXWrkf.Reset();
                    TempL_RFLEXWrkf.DeleteAll(false);
                    TempL_RFLEXWrkf.Init();
                    TempL_RFLEXWrkf.Key := 1;

                    TempL_RFLEXWrkf.Num01 := L_RProdOrdL.Quantity;
                    TempL_RFLEXWrkf.Num02 := L_RProdOrdL."Finished Quantity";
                    TempL_RFLEXWrkf.Num03 := L_RProdOrdL."Remaining Quantity";
                    TempL_RFLEXWrkf.Txt01 := L_RProdOrdL."Prod. Order No.";
                    TempL_RFLEXWrkf.Txt02 := L_RProdOrdL."Item No.";
                    TempL_RFLEXWrkf.Txt04 := CopyStr(PadStr(L_RProdOrdL.Description, MaxStrLen(L_RProdOrdL.Description)) +
                                                    PadStr(L_RProdOrdL."Description 2", MaxStrLen(L_RProdOrdL."Description 2")),
                                                    1, MaxStrLen(TempL_RFLEXWrkf.Txt04));
                    TempL_RFLEXWrkf.Date01 := L_RProdOrdL."Ending Date";

                    TempL_RFLEXWrkf.Insert(false);

                    L_VisEdt[5, 1] := true;
                    L_VisEdt[5, 2] := true;
                    L_VisEdt[6, 1] := true;
                    L_VisEdt[6, 2] := false;
                    L_VisEdt[7, 1] := true;
                    L_VisEdt[7, 2] := false;
                    L_VisEdt[9, 1] := true;
                    L_VisEdt[9, 2] := false;
                    L_VisEdt[10, 1] := true;
                    L_VisEdt[10, 2] := false;
                    L_VisEdt[11, 1] := true;
                    L_VisEdt[11, 2] := false;
                    L_VisEdt[12, 1] := true;
                    L_VisEdt[12, 2] := false;

                    L_VisEdt[21, 1] := true;
                    L_VisEdt[21, 2] := true;
                    L_FieldCaption[5] := CopyStr(L_RProdOrdL.FieldCaption(Quantity), 1, MaxStrLen(L_FieldCaption[5]));
                    L_FieldCaption[6] := CopyStr(L_RProdOrdL.FieldCaption("Finished Quantity"), 1, MaxStrLen(L_FieldCaption[6]));
                    L_FieldCaption[7] := CopyStr(L_RProdOrdL.FieldCaption("Remaining Quantity"), 1, MaxStrLen(L_FieldCaption[7]));
                    L_FieldCaption[9] := CopyStr(L_RProdOrdL.FieldCaption("Prod. Order No."), 1, MaxStrLen(L_FieldCaption[9]));
                    L_FieldCaption[10] := CopyStr(L_RProdOrdL.FieldCaption("Item No."), 1, MaxStrLen(L_FieldCaption[10]));
                    L_FieldCaption[11] := CopyStr(L_RProdOrdL.FieldCaption("Variant Code"), 1, MaxStrLen(L_FieldCaption[11]));
                    L_FieldCaption[12] := CopyStr(L_RProdOrdL.FieldCaption(Description), 1, MaxStrLen(L_FieldCaption[12]));
                    L_FieldCaption[21] := CopyStr(L_RProdOrdL.FieldCaption("Ending Date"), 1, MaxStrLen(L_FieldCaption[21]));
                    L_WinTitle := L_Text001;
                    L_PGGenericDataInput.SetFields(L_VisEdt, L_FieldCaption, L_WinTitle, L_Instructions, TempL_RFLEXWrkf);
                    L_Exit := false;
                    L_Error := false;
                    while not L_Exit do begin
                        L_Error := false;
                        if L_PGGenericDataInput.RunModal() in [Action::OK, Action::LookupOK] then begin
                            L_PGGenericDataInput.GetRecord(TempL_RFLEXWrkf);
                            if TempL_RFLEXWrkf.Num01 < TempL_RFLEXWrkf.Num02 then begin
                                Message(L_Text002, TempL_RFLEXWrkf.Num02);
                                L_Error := true;
                            end;
                            if TempL_RFLEXWrkf.Date01 = 0D then begin
                                Message(L_Text004);
                                L_Error := true;
                            end;
                            if (TempL_RFLEXWrkf.Date01 <> L_RProdOrdL."Ending Date") and
                               (TempL_RFLEXWrkf.Date01 < WorkDate()) then begin
                                Message(L_Text005);
                                L_Error := true;
                            end;
                            if not L_Error then begin
                                if (TempL_RFLEXWrkf.Num01 <> L_RProdOrdL.Quantity) or
                                   (TempL_RFLEXWrkf.Date01 <> L_RProdOrdL."Ending Date") then begin
                                    // IF (L_RTmpFLEXWrkf.Num01 <> Quantity) THEN
                                    L_RProdOrdL.Validate(Quantity, TempL_RFLEXWrkf.Num01);
                                    // IF (L_RTmpFLEXWrkf.Date01 <> "Ending Date") THEN
                                    L_RProdOrdL.Validate("Ending Date", TempL_RFLEXWrkf.Date01);
                                    L_RProdOrdL.Modify(true);
                                    Rec."Operation Quantity (Base)" := L_RProdOrdL."Quantity (Base)";
                                    Rec."Operation Finished Qty. (Base)" := L_RProdOrdL."Finished Qty. (Base)";
                                    Rec."Operation Rem. Qty. (Base)" := L_RProdOrdL."Remaining Qty. (Base)";
                                    Rec.Modify(false);
                                    Commit();
                                    // Aggiorno la quantità sui Componenti
                                    TempRSubcFeas1.Reset();
                                    TempRSubcFeas1.SetRange(Status, Rec.Status);
                                    TempRSubcFeas1.SetRange("Prod. Order No.", Rec."Prod. Order No.");
                                    TempRSubcFeas1.SetRange("Prod. Order Line No.", Rec."Line No.");
                                    if TempRSubcFeas1.Find('-') then
                                        repeat
                                            if L_RProdOrdComp.Get(TempRSubcFeas1.Status, TempRSubcFeas1."Prod. Order No.", TempRSubcFeas1.
                                                               "Prod. Order Line No.", TempRSubcFeas1."Line No.") then begin
                                                TempRSubcFeas1."Quantity per" := L_RProdOrdComp."Quantity per";
                                                TempRSubcFeas1."Remaining Qty. (Base)" := L_RProdOrdComp."Remaining Qty. (Base)";
                                                TempRSubcFeas1."Quantity (Base)" := L_RProdOrdComp."Quantity (Base)";
                                                TempRSubcFeas1."Expected Qty. (Base)" := L_RProdOrdComp."Expected Qty. (Base)";
                                                TempRSubcFeas1.Modify(false);
                                            end;

                                        until TempRSubcFeas1.Next() = 0;
                                    Commit();
                                    //  CSubcontractor.SubcontractorOrderFeasibility(Rec, TempRSubcFeas1, TempRSubcFeas2);


                                    //TODO commentata perché andava in errore, da sostiture con le procedure F_SetQtyOnSubcFeas1 e F_FillDictionary
                                    // SubcontractorOrderFeasibility(Rec, TempRSubcFeas1, TempRSubcFeas2);



                                    Commit();
                                    // Aggiorno l'ordine di conto lavoro
                                    L_RPurchL.SetCurrentKey("Document Type", Type, "Prod. Order No.", "Prod. Order Line No.", "Routing No.", "Operation No.");
                                    L_RPurchL.SetRange("Document Type", L_RPurchL."Document Type"::Order);
                                    L_RPurchL.SetRange(Type, L_RPurchL.Type::Item);
                                    L_RPurchL.SetRange("Prod. Order No.", L_RProdOrdL."Prod. Order No.");
                                    L_RPurchL.SetRange("Prod. Order Line No.", L_RProdOrdL."Line No.");
                                    if L_RPurchL.FindLast() then begin
                                        L_RPurchL.SuspendStatusCheck(true);
                                        L_RPurchL.Validate("Promised Receipt Date", TempL_RFLEXWrkf.Date01);
                                        L_RPurchL.Modify(true);
                                        Commit();
                                        Message(L_Text003, L_RPurchL."Document No.");
                                    end;
                                end;
                                L_Exit := true;
                                CurrPage.Update();
                            end;
                            L_Error := false;
                        end
                        else
                            L_Exit := true;
                    end;
                    CurrPage.Update();
                end;
            }
            action(SubcontractionOrder)
            {
                Caption = 'Subcontractiong Orders Creation';
                // Enabled = SubOrders;
                Enabled = false;
                Image = ImportExport;
                //TODO per ora nascosto, vedere se mantenere l'azione di creazione dell'ordine di conto lavoro, l'azione di cambio data e qtà direi seccare
                Visible = false;

                trigger OnAction()
                var
                    L_RProdOrdL: Record "Prod. Order Line";
                    TempL_RProdOrdL: Record "Prod. Order Line" temporary;
                    L_RProdOrd: Record "Production Order";
                    TempL_RSubcFeas1: Record "TMP Subc. Feasibility 1 PTE" temporary;
                    TempL_RSubcFeas: Record "TMP Subc. Feasibility PTE" temporary;
                    L_CUProdOrdStatusMgt: Codeunit "Prod. Order Status Management";
                    L_CUProduction: Codeunit "Production Codeunit FLE";
                begin
                    L_RProdOrd.Get(Rec.Status, Rec."Prod. Order No.");
                    if L_RProdOrd.Status = Rec.Status::"Firm Planned" then begin
                        L_CUProdOrdStatusMgt.ChangeProdOrderStatus(L_RProdOrd, L_RProdOrd.Status::Released, WorkDate(), false);
                        TempL_RSubcFeas1.Copy(TempRSubcFeas1, true);
                        TempRSubcFeas1.SetRange(Status, Rec.Status);
                        TempRSubcFeas1.SetRange("Prod. Order No.", Rec."Prod. Order No.");
                        TempRSubcFeas1.SetRange("Prod. Order Line No.", Rec."Line No.");
                        if TempRSubcFeas1.Find('-') then
                            repeat
                                TempL_RSubcFeas1 := TempRSubcFeas1;
                                TempL_RSubcFeas1.Rename(TempL_RSubcFeas1.Status::Released, TempL_RSubcFeas1."Prod. Order No.",
                                                       TempL_RSubcFeas1."Prod. Order Line No.", TempL_RSubcFeas1."Line No.");
                            until TempRSubcFeas1.Next() = 0;
                        Rec.Status := Rec.Status::Released;
                        Rec.Modify(false);
                        Commit();
                    end;
                    L_RProdOrd.Get(Rec.Status::Released, Rec."Prod. Order No.");
                    L_CUProduction.CreateSubcontrOrders(L_RProdOrd, true, true, false);
                    Commit();
                    L_RProdOrdL.Get(Rec.Status::Released, Rec."Prod. Order No.", Rec."Line No.");
                    Rec.Modify(false);
                    Commit();
                    // Aggiorno Tutti gli ordini coinvolti
                    TempL_RProdOrdL.Reset();
                    TempL_RProdOrdL.DeleteAll(false);
                    TempRSubcFeas1.Reset();
                    TempRSubcFeas1.SetRange(Status, L_RProdOrdL.Status);
                    TempRSubcFeas1.SetRange("Prod. Order No.", L_RProdOrdL."Prod. Order No.");
                    TempRSubcFeas1.SetRange("Prod. Order Line No.", L_RProdOrdL."Line No.");
                    if TempRSubcFeas1.FindSet() then begin
                        TempL_RSubcFeas1.Copy(TempRSubcFeas1, true);
                        TempL_RSubcFeas1.Reset();
                        TempL_RSubcFeas1.SetCurrentKey("Item No.", "Variant Code");
                        if TempRSubcFeas2.Get(TempRSubcFeas1."Item No.", TempRSubcFeas1."Variant Code") then begin
                            TempRSubcFeas2.CalcQty();
                            TempRSubcFeas2.Modify(false);
                        end;
                        repeat
                            TempL_RSubcFeas1.SetRange("Item No.", TempRSubcFeas1."Item No.");
                            TempL_RSubcFeas1.SetRange("Variant Code", TempRSubcFeas1."Variant Code");
                            if TempL_RSubcFeas1.FindSet() then
                                repeat
                                    if not TempL_RProdOrdL.Get(TempL_RSubcFeas1.Status,
                                                              TempL_RSubcFeas1."Prod. Order No.",
                                                              TempL_RSubcFeas1."Prod. Order Line No.") then begin
                                        TempL_RProdOrdL.Init();
                                        TempL_RProdOrdL.Status := TempL_RSubcFeas1.Status;
                                        TempL_RProdOrdL."Prod. Order No." := TempL_RSubcFeas1."Prod. Order No.";
                                        TempL_RProdOrdL."Line No." := TempL_RSubcFeas1."Prod. Order Line No.";
                                        TempL_RProdOrdL.Insert(false);
                                    end;
                                until TempL_RSubcFeas1.Next() = 0;
                        until TempRSubcFeas1.Next() = 0;
                        Commit();
                        //                         if TempL_RProdOrdL.FindSet() then begin
                        //                             TempL_RSubcFeas.Copy(Rec, true);
                        //                             repeat
                        //                                 if TempL_RSubcFeas.Get(TempL_RProdOrdL."Prod. Order No.", TempL_RProdOrdL."Line No.") then
                        // CSubcontractor.SubcontractorOrderFeasibility(TempL_RSubcFeas, TempRSubcFeas1, TempRSubcFeas2);


                        //TODO commentata perché andava in errore, da sostiture con le procedure F_SetQtyOnSubcFeas1 e F_FillDictionary
                        // SubcontractorOrderFeasibility(TempL_RSubcFeas, TempRSubcFeas1, TempRSubcFeas2);


                        //                           until TempL_RProdOrdL.Next() = 0
                        //                         end;
                    end;
                    TempRSubcFeas1.Reset();
                    CurrPage.Update();
                end;
            }
        }
        area(Navigation)
        {
            group(ViewCard)
            {
                action(ViewItem)
                {
                    Caption = 'Item';
                    Image = EditLines;
                    RunObject = page "Item Card";
                    RunPageLink = "No." = field("Item No.");
                    RunPageMode = View;
                    RunPageOnRec = false;
                    ShortcutKey = 'Shift+Ctrl+C';
                    Enabled = BViewItemActionEnabled;
                }
                action(ViewProdOrder)
                {
                    Caption = 'Prod. Order';
                    Image = SetupList;
                    ShortcutKey = 'Return';
                    Enabled = BViewProdOrderActionEnabled;

                    trigger OnAction()
                    var
                        L_RProdOrd: Record "Production Order";
                    begin
                        CProduction.ShowProductionOrder(Rec."Prod. Order No.", true, false);
                    end;
                }
                action(ViewSubcontractorOrders)
                {
                    caption = 'Subcontractor Orders';
                    Image = OrderTracking;
                    Enabled = BViewSubcontractorOrderActionEnabled;
                    ToolTip = 'Shows all subcontracting orders that have not yet been completed.';

                    trigger OnAction()
                    var
                        L_RPurchLine: Record "Purchase Line";
                        L_RWorkCenter: Record "Work Center";
                        L_WorkCenterCode: Code[20];
                    begin
                        L_RPurchLine.Reset();
                        L_RPurchLine.SetCurrentKey("Document Type", "Buy-from Vendor No.");
                        L_RPurchLine.FilterGroup(20);
                        L_RPurchLine.SetRange("Document Type", L_RPurchLine."Document Type"::Order);
                        L_RPurchLine.SetFilter("Prod. Order No.", '<>%1', '');
                        L_RPurchLine.SetFilter("Outstanding Quantity", '>0');
                        L_RPurchLine.FilterGroup(0);
                        L_WorkCenterCode := Rec.Subcontractor;
                        if L_WorkCenterCode <> '' then
                            if L_RWorkCenter.Get(L_WorkCenterCode) then
                                L_RPurchLine.SetRange("Buy-from Vendor No.", L_RWorkCenter."Subcontractor No.");
                        Page.Run(Page::"Purchase Lines", L_RPurchLine);
                    end;
                }
            }
            action(Availability)
            {
                Caption = 'Availability';
                Image = Trace;
                ShortcutKey = 'Return';
                Enabled = BAvailabilityActionEnabled;

                trigger OnAction()
                var
                    L_CProduction: Codeunit "Production Codeunit FLE";
                begin
                    if Rec."Item No." <> '' then
                        L_CProduction.ShowItemAvailability(Rec."Item No.", '', '');
                end;
            }
            //TODO Gruppo che sarà da spostare in Flex_Manufacturing_Interface perché la pagina è nella starter
            group(BinContent)
            {
                Caption = 'Bin Content';
                action(BinContentInternalLocation)
                {
                    Caption = 'Bin Content Internal Location';
                    Image = BinContent;
                    Enabled = BBinContentInternalLocationEnabled;

                    trigger OnAction()
                    begin
                        F_ShowBinContent(Rec."Item No.", Rec."Variant Code", Rec."Location Code");
                    end;
                }
                action(BinContentExternalLocation)
                {
                    Caption = 'Bin Content External Location';
                    Image = GetBinContent;
                    Enabled = BBinContentExternalLocationEnabled;

                    trigger OnAction()
                    begin
                        F_ShowBinContent(Rec."Item No.", Rec."Variant Code", Rec."Subcontracting Location Code");
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(LoadData_Promoted; LoadData)
                {
                }
                actionref(AllOrders_Promoted; AllOrders)
                {
                }
                actionref(OnlyFeasibleOrders_Promoted; OnlyFeasibleOrders)
                {
                }
                group(InventoryComponentsFilters_Promoted)
                {
                    Caption = 'Components Filters';
                    Visible = (not BComponentUsingInventoryFilterApplied);
                    actionref(FilterProdOrdersForComponentUsingInternalInventory_Promoted; FilterProdOrdersForComponentUsingInternalInventory)
                    {
                    }
                    actionref(FilterProdOrdersForComponentUsingExternalInventory_Promoted; FilterProdOrdersForComponentUsingExternalInventory)
                    {
                    }
                }
                actionref(RemoveFilterOnProdOrderComponent_Promoted; RemoveFilterOnProdOrderComponent)
                {
                }
                group(TransferOrders_Promoted)
                {
                    Caption = 'Transfer Orders';
                    actionref(CreateTransferOrderForSelectedComponents_Promoted; CreateTransferOrderForSelectedComponents)
                    {
                    }
                    actionref(CreateTransferOrderForMissingComponents_Promoted; CreateTransferOrderForMissingComponents)
                    {
                    }
                }
            }
            group(Category4)
            {
                Caption = 'View';
                actionref(ViewItem_Promoted; ViewItem)
                {
                }
                actionref(ViewProdOrder_Promoted; ViewProdOrder)
                {
                }
                actionref(ViewSubcontractorOrders_Promoted; ViewSubcontractorOrders)
                {
                }
                actionref(Availability_Promoted; Availability)
                {
                }
                group(BinContent_Promoted)
                {
                    Caption = 'Bin Content';
                    actionref(BinContentInternalLocation_Promoted; BinContentInternalLocation)
                    {
                    }
                    actionref(BinContentExternalLocation_Promoted; BinContentExternalLocation)
                    {
                    }
                }
            }
            group(Category5)
            {
                Caption = 'Production Order';
                actionref(QtyUpdateDate_Promoted; QtyUpdateDate)
                {
                }
                actionref(SubcontractionOrder_Promoted; SubcontractionOrder)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        F_SetStyle();
    end;

    trigger OnOpenPage()
    begin
        SubcontractorNoFilter := '';
        CurrPage.ComponentsPart.Page.GetTmpRec(Rec, TempRSubcFeas1, TempRSubcFeas2);
        CurrPage.ConflictPart.Page.GetTmpRec(Rec, TempRSubcFeas1);
        TempRSubcFeas1_2.Copy(TempRSubcFeas1, true);
    end;

    trigger OnAfterGetCurrRecord()
    var
        L_RLocation: Record Location;
    begin
        F_SetControls();
    end;

    var
        CConfirmManagement: Codeunit "Confirm Management";
        TempRSubcFeas1: Record "TMP Subc. Feasibility 1 PTE" temporary;
        TempRSubcFeas1_2: Record "TMP Subc. Feasibility 1 PTE" temporary;
        TempRSubcFeas2: Record "TMP Subc. Feasibility 2 FLE" temporary;
        CSubcontractor: Codeunit "Subcontractor Codeunit FLE";
        CGeneralManufacturing: Codeunit "General Manufacturing FLE";
        CProduction: Codeunit "Production Codeunit FLE";
        CSelectionFilterMgt: Codeunit SelectionFilterManagement;
        BFeasibleOnly: Boolean;
        BIncludeFirmPlanned: Boolean;
        ShowComplete_S: Boolean;
        SubOrders: Boolean;
        SubcontractorNoFilter, ItemNoFilter, StandardTaskCodeFilter : Text;
        ItemNoComponentFilter: Code[20];
        VariantCodeComponentFilter: Code[10];
        DueDateToFilter: Date;
        InternalLocationFilter: Text;
        RecStyle: Text;
        BEnableComponentVariantCodeFilter: Boolean;
        IsComponentFilterSet: Boolean;
        BCalcReservationBasedOnMaxFeasibleQty: Boolean;
        BComponentUsingInventoryFilterApplied: Boolean;
        BBinContentInternalLocationEnabled, BBinContentExternalLocationEnabled, BTransferOrderActionEnabled, BFeasibleFilterEnabled, BInternalInventoryComponentsFilterEnabled, BExternalInventoryComponentsFilterEnabled : Boolean;
        BViewItemActionEnabled, BViewProdOrderActionEnabled, BViewSubcontractorOrderActionEnabled, BAvailabilityActionEnabled : Boolean;
        BDisableActionAndDrillDownAtDueDateChange: Boolean;
        ExpectedReceiptQtyForComponent: Dictionary of [Code[30], Decimal]; // Nr. articolo + Cod. variante, Qtà
        GlobalQtyInTransferOrderPerInternalLocationAndComponent: Dictionary of [Code[10], Dictionary of [Code[30], Decimal]]; // Cod. ubicazione interna, Nr. articolo + Cod. variante, Qtà in ordine di trasferimento
        TransferredQtyPerComponent: Dictionary of [Code[10], Dictionary of [Code[10], Dictionary of [Code[30], Decimal]]]; // Cod. ubicazione interna, Cod. ubicazione esterna, Nr. articolo + Cod. variante, Qtà in ordine di trasferimento
        TotalInternalInventoryAlreadyUsed: Dictionary of [Code[10], Dictionary of [Code[30], Decimal]]; // Cod. ubicazione, Nr. articolo + Cod. variante, Giacenza esterna già utilizzata
        TotalExternalInventoryAlreadyUsed: Dictionary of [Code[20], Dictionary of [Code[30], Decimal]]; // Nr. terzista, Nr. articolo + Cod. variante, Giacenza esterna già utilizzata
        ProdOrderNoForDrillDownInternalQtyUsedByOtherPerProdOrder, ProdOrderNoForDrillDownExternalQtyUsedByOtherPerProdOrder : Dictionary of [Text, Dictionary of [Code[30], Dictionary of [Code[10], Text]]]; // Nr. ODP, Nr. articolo + Cod. variante, Cod. ubicazione, lista Nr. ODP
        ProdOrderNoForDrillDownInternalQtyUsedByOther, ProdOrderNoForDrillDownExternalQtyUsedByOther : Dictionary of [Code[30], Dictionary of [Code[10], Text]]; // Nr. articolo + Cod. variante, Cod. ubicazione, lista Nr. ODP

    local procedure F_LoadData()
    begin
        F_FillTable();
        Rec.Reset();
        F_SetCurrentKeyOnRec();
        F_SetFilters();
        if Rec.FindFirst() then;
    end;

    local procedure F_SetFilters()
    begin
        Rec.FilterGroup(20);
        if SubcontractorNoFilter <> '' then
            Rec.SetFilter(Subcontractor, SubcontractorNoFilter)
        else
            Rec.SetRange(Subcontractor);
        if ItemNoFilter <> '' then
            Rec.SetFilter("Item No.", ItemNoFilter)
        else
            Rec.SetRange("Item No.");
        if StandardTaskCodeFilter <> '' then
            Rec.SetFilter("Standard Task Code", StandardTaskCodeFilter)
        else
            Rec.SetRange("Standard Task Code");
        if ShowComplete_S then
            Rec.SetRange("Subcontractor Order")
        else
            Rec.SetRange("Subcontractor Order", '');
        if BFeasibleOnly then
            Rec.SetRange("Full Feasible", true)
        else
            Rec.SetRange("Full Feasible");
        Rec.FilterGroup(0);
    end;

    local procedure F_SetStyle()
    begin
        case true of
            Rec."Full Feasible":
                RecStyle := 'Favorable';
            Rec."Partially Feasible":
                RecStyle := 'StrongAccent';
            else
                RecStyle := '';
        end;
    end;

    local procedure F_DisableAction()
    begin
        SubOrders := false;
        BBinContentInternalLocationEnabled := false;
        BBinContentExternalLocationEnabled := false;
        BTransferOrderActionEnabled := false;
        BFeasibleFilterEnabled := false;
        BViewItemActionEnabled := false;
        BViewProdOrderActionEnabled := false;
        BViewSubcontractorOrderActionEnabled := false;
        BAvailabilityActionEnabled := false;
        BInternalInventoryComponentsFilterEnabled := false;
        BExternalInventoryComponentsFilterEnabled := false;
    end;

    local procedure F_SetControls()
    var
        L_RLocation: Record Location;
        L_BIsProdOrderExternal: Boolean;
    begin
        F_SetStyle();
        F_DisableAction();

        if Rec.IsEmpty then
            exit;

        BViewItemActionEnabled := true;
        BViewProdOrderActionEnabled := true;
        BAvailabilityActionEnabled := true;

        if BDisableActionAndDrillDownAtDueDateChange then
            exit;

        //TODO vedere se tenere questo controllo e in generale l'azione nella quale è chiamata
        SubOrders := Rec."Subcontractor Order" = '';

        BBinContentInternalLocationEnabled := Rec."Location Code" <> '';
        BBinContentExternalLocationEnabled := Rec."Subcontracting Location Code" <> '';
        L_BIsProdOrderExternal := F_CheckThatProdOrderIsExternal(Rec);
        if L_BIsProdOrderExternal then begin
            BTransferOrderActionEnabled := true;
            BViewSubcontractorOrderActionEnabled := true;
        end;
        BFeasibleFilterEnabled := true;

        TempRSubcFeas1_2.reset;
        TempRSubcFeas1_2.FilterComponentByProdOrder(Rec);
        if not TempRSubcFeas1_2.IsEmpty then begin
            BInternalInventoryComponentsFilterEnabled := true;
            if L_BIsProdOrderExternal then
                BExternalInventoryComponentsFilterEnabled := true;
        end;
    end;

    local procedure F_ClearGlobalVar()
    begin
        Clear(TotalInternalInventoryAlreadyUsed);
        Clear(TotalExternalInventoryAlreadyUsed);
        Clear(ProdOrderNoForDrillDownInternalQtyUsedByOtherPerProdOrder);
        Clear(ProdOrderNoForDrillDownInternalQtyUsedByOther);
        Clear(ProdOrderNoForDrillDownExternalQtyUsedByOtherPerProdOrder);
        Clear(ProdOrderNoForDrillDownExternalQtyUsedByOther);
        Clear(GlobalQtyInTransferOrderPerInternalLocationAndComponent);
        Clear(TransferredQtyPerComponent);
        BDisableActionAndDrillDownAtDueDateChange := false;
    end;

    local procedure F_FilterProdOrderLineToCalcFeasibility(var V_RProdOrderLine: Record "Prod. Order Line"; P_BSetComponentFilter: Boolean; P_BSetDueDateFilter: Boolean)
    var
        L_ProdOrderNoFilter: Text;
    begin
        //TODO vedere se definire questa chiave
        V_RProdOrderLine.SetCurrentKey(Status, "Due Date", "Prod. Order No.", "Line No.");
        V_RProdOrderLine.SetFilter("Remaining Qty. (Base)", '>0');
        if P_BSetComponentFilter then begin
            F_CreateProdOrderFilterFromComponentFilter(L_ProdOrderNoFilter);
            V_RProdOrderLine.SetFilter("Prod. Order No.", L_ProdOrderNoFilter);
        end;
        if P_BSetDueDateFilter then
            V_RProdOrderLine.SetRange("Due Date", 0D, DueDateToFilter);
    end;

    local procedure F_CreateInternalLocationFilter()
    var
        L_RLocation: Record Location;
    begin
        if InternalLocationFilter = '' then
            exit;
        L_RLocation.SetRange("Vendor Subcontracting FLE", false);
        L_RLocation.SetRange("Customer Subcontracting FLE", false);
        L_RLocation.SetRange("Third Party Properties FLE", false);
        L_RLocation.SetRange("Excluded From MRP FLE", false);
        InternalLocationFilter := L_RLocation.FLE_MakeLocationFilter();
        CurrPage.ComponentsPart.Page.SetInternalLocationFilter(InternalLocationFilter);
    end;

    local procedure F_FillTable()
    var
        L_RItem: Record Item;
        L_RItem2: Record Item;
        L_RProdOrdL: Record "Prod. Order Line";
        L_RProdOrdRoutL: Record "Prod. Order Routing Line";
        L_RWorkCenter: Record "Work Center";
        L_RVendor: Record Vendor;
        L_OK: Boolean;
        L_ProgressWin: Dialog;
        L_Counter, L_Counter2 : Integer;
        L_Indentation: Integer;
        L_NoOfRecords: Integer;
        L_TextProg01: Label 'Work in progress...';
        L_TextProg01a: Label 'Feasibility Production Orders Processing...\\';
        L_TextProg02: Label 'Progress';
        L_TextProg03: Label 'Processed';
        L_TextProg04: Label 'Of';
        L_TextProg05: Label 'Production Orders';
        L_ConfirmLoadProdOrderWithoutDateFilter: Label 'The "Up To Starting Date" filter has not been set. Are you sure you want to load production orders? %1 production orders will be loaded.';
        L_Filter1: Text;
        L_Filter2: Text;
        L_RLocation: Record Location;
        L_CSelectionFilterMgt: Codeunit SelectionFilterManagement;
        L_CConfigProgressBar: Codeunit "Config. Progress Bar";
        L_WindowsUpdateCount: Integer;
        L_ProdOrderNoFilter: Text;
        L_ProdOrderNoListFilter: List of [Code[20]];
        L_IsHandled: Boolean;
        L_DateTime: DateTime;
    begin
        F_ClearGlobalVar();

        F_CreateInternalLocationFilter();

        Rec.Reset();
        Rec.DeleteAll(false);
        TempRSubcFeas1.Reset();
        TempRSubcFeas1.DeleteAll(false);
        TempRSubcFeas2.Reset();
        TempRSubcFeas2.DeleteAll(false);
        Commit();

        L_RProdOrdL.Reset();
        F_FilterProdOrderLineToCalcFeasibility(L_RProdOrdL, IsComponentFilterSet, (DueDateToFilter <> 0D));

        //TODO da valutare se mettere IsHandled. Più che altro se mi mettono IsHandled a true vuol dire che viene saltato tutto il calcolo. Quindi mi sembra un po' forte.
        L_IsHandled := false;
        OnBeforeCalcFeasibilityOnAfterSetFilterOnProdOrderLine(Rec,
                                                               L_RProdOrdL,
                                                               TempRSubcFeas1,
                                                               BIncludeFirmPlanned,
                                                               ItemNoComponentFilter,
                                                               VariantCodeComponentFilter,
                                                               L_IsHandled);
        if L_IsHandled then
            exit;

        L_RProdOrdL.SetRange(Status, L_RProdOrdL.Status::Released);
        F_CalcFeasibility(L_RProdOrdL, Rec, TempRSubcFeas1);

        if BIncludeFirmPlanned then begin
            L_RProdOrdL.SetRange(Status, L_RProdOrdL.Status::"Firm Planned");
            F_CalcFeasibility(L_RProdOrdL, Rec, TempRSubcFeas1);
        end;

        //TODO se blocco il caricamento prima che finisca non vanno i drilldown
        //Capire se lasciare comunque qua il passaggio dei dizionari alla subpage oppure spostarlo
        //Nel caso sarebbe da passare per ogni ordine di produzione che viene calcolato. Quindi sono un botto di chiamate in più


        //Se blocco il caricamento prima che finisca non vanno i drilldown
        CurrPage.ComponentsPart.Page.GetProdOrderDictionary(ProdOrderNoForDrillDownInternalQtyUsedByOtherPerProdOrder, ProdOrderNoForDrillDownExternalQtyUsedByOtherPerProdOrder);
        //Abilito il drill down qui in modo che siano disattivati se il caricamento viene bloccato prima
        CurrPage.ComponentsPart.Page.EnableDrillDownOnInventoryUsedByOther();

        Rec.Reset();
    end;

    procedure F_CalcFeasibility(var V_RProdOrderLine: Record "Prod. Order Line"; var V_RTMPSubcFeas: Record "TMP Subc. Feasibility PTE" temporary; var V_RTMPSubcFeas1: Record "TMP Subc. Feasibility 1 PTE" temporary)
    var
        L_RItem: Record Item;
        L_RItem2: Record Item;
        L_RProdOrdComp: Record "Prod. Order Component";
        L_RProdOrdRoutL: Record "Prod. Order Routing Line";
        L_RWorkCenter: Record "Work Center";
        L_RVendor: Record Vendor;
        L_RCapacityLedgerEntry: Record "Capacity Ledger Entry";
        L_OK: Boolean;
        L_ProgressWin: Dialog;
        L_Counter, L_Counter2 : Integer;
        L_Indentation: Integer;
        L_NoOfRecords: Integer;
        L_TextProg01: Label 'Work in progress...';
        L_TextProg01a: Label 'Feasibility Production Orders Processing...\\';
        L_TextProg02: Label 'Progress';
        L_TextProg03: Label 'Processed %1 of %2';
        L_TextProg04: Label 'Of';
        L_TextProg05: Label '%1 Production Orders';
        L_ReleasedLbl: Label 'Released';
        L_FirmPlannedLbl: Label 'Firm Planned';
        L_Filter1: Text;
        L_Filter2: Text;
        L_RLocation: Record Location;
        L_CSelectionFilterMgt: Codeunit SelectionFilterManagement;
        L_CConfigProgressBar: Codeunit "Config. Progress Bar";
        L_WindowsUpdateCount: Integer;
        L_OrderStatusText: Text;
        L_SubcontractorLocationCode: Code[20];
        L_ProdOrderSubcontractorFeasableQty, L_ProdOrderInternalFeasableQty : Decimal;
        L_ComponentSubcontractorFeasableQty, L_ComponentInternalFeasableQty : Decimal;
        L_TotalComponentFeasableQty: Decimal;
    begin
        if V_RProdOrderLine.FindSet() then begin
            if GuiAllowed then begin
                L_NoOfRecords := V_RProdOrderLine.Count;
                L_WindowsUpdateCount := Round(((L_NoOfRecords * 2.5) / 100), 1); //Calcolo il 2,5% del totale. Sarà la frequenza di aggiornamento della finestra
                L_CConfigProgressBar.Init(L_NoOfRecords, 1, L_TextProg01);
                case V_RProdOrderLine.Status of
                    V_RProdOrderLine.Status::Released:
                        L_OrderStatusText := L_ReleasedLbl;
                    V_RProdOrderLine.Status::"Firm Planned":
                        L_OrderStatusText := L_FirmPlannedLbl;
                    else
                //TODO evento
                end;
            end;
            repeat
                if GuiAllowed then begin
                    L_Counter += 1;
                    L_Counter2 += 1;
                    if (L_Counter2 = L_WindowsUpdateCount) or (L_Counter = L_NoOfRecords) then begin
                        L_CConfigProgressBar.Update(StrSubstNo('%1 %2', StrSubstNo(L_TextProg03, L_Counter, L_NoOfRecords), StrSubstNo(L_TextProg05, L_OrderStatusText)));
                        L_Counter2 := 0;
                    end;
                end;
                V_RTMPSubcFeas.Init();
                L_RItem.SetLoadFields(Description, "Planning Group FLE", "Item Category Code");
                if not L_RItem.Get(V_RProdOrderLine."Item No.") then
                    Clear(L_RItem);
                V_RTMPSubcFeas.TransferFields(V_RProdOrderLine);
                V_RTMPSubcFeas."Item Description" := L_RItem.Description;
                V_RTMPSubcFeas."Planning Group" := L_RItem."Planning Group FLE";

                CGeneralManufacturing.FilterProdOrderRoutingLineFromProdOrderLine(L_RProdOrdRoutL, V_RProdOrderLine);
                L_RProdOrdRoutL.SetFilter("Routing Link Code", '<>%1', '');
                //TODO sarebbe da fare findset e per ogni routing line dello stesso ODP che trova duplicare la riga
                //TODO Magari fare visualizzazione ad albero nel caso di ordini che hanno più fasi che prelevano
                if L_RProdOrdRoutL.FindFirst() then begin
                    if L_RProdOrdRoutL."External Operation FLE" then begin
                        if GetSubcontractorLocationFromProdOrderRoutingLine(L_RProdOrdRoutL, L_RWorkCenter, L_SubcontractorLocationCode) then
                            //TODO può essere che ci siano più di un terzista sul ciclo dell'ODP, quindi questo non può essere segnato sulla riga dell'ordine ma è da spostare
                            V_RTMPSubcFeas."Subcontracting Location Code" := L_SubcontractorLocationCode;
                        V_RTMPSubcFeas.Subcontractor := L_RProdOrdRoutL."Work Center No.";
                        V_RTMPSubcFeas."Subcontractor Name" := L_RWorkCenter.Name;
                    end;
                    // end else
                    //     exit;

                    // Imposto le quantità dell'operazione
                    V_RTMPSubcFeas."Operation Quantity (Base)" := L_RProdOrdRoutL."Input Quantity";
                    L_RCapacityLedgerEntry.SetFilterByProdOrderRoutingLine(V_RProdOrderLine."Prod. Order No.", V_RProdOrderLine."Line No.",
                                                                           L_RProdOrdRoutL."Routing No.", L_RProdOrdRoutL."Routing Reference No.");
                    L_RCapacityLedgerEntry.CalcSums("Output Quantity", "Scrap Quantity");
                    V_RTMPSubcFeas."Operation Finished Qty. (Base)" := L_RCapacityLedgerEntry."Output Quantity";
                    if L_RProdOrdRoutL."Routing Status" = L_RProdOrdRoutL."Routing Status"::Finished then
                        V_RTMPSubcFeas."Operation Rem. Qty. (Base)" := 0
                    else
                        V_RTMPSubcFeas."Operation Rem. Qty. (Base)" := V_RTMPSubcFeas."Operation Quantity (Base)" - V_RTMPSubcFeas."Operation Finished Qty. (Base)";

                    if V_RTMPSubcFeas.Subcontractor <> '' then
                        L_ProdOrderSubcontractorFeasableQty := V_RTMPSubcFeas."Operation Rem. Qty. (Base)";
                    L_ProdOrderInternalFeasableQty := V_RTMPSubcFeas."Operation Rem. Qty. (Base)";
                    L_TotalComponentFeasableQty := V_RTMPSubcFeas."Operation Rem. Qty. (Base)";

                    // Solo se ho del residuo
                    if V_RTMPSubcFeas."Operation Rem. Qty. (Base)" > 0 then begin
                        // L_RProdOrdRoutL.SetRange("External Operation FLE");

                        if V_RTMPSubcFeas."Subcontractor Order" <> '' then
                            V_RTMPSubcFeas."Status Order" := '0'
                        else
                            V_RTMPSubcFeas."Status Order" := Format(9 - V_RProdOrderLine.Status.AsInteger());

                        V_RTMPSubcFeas.Insert(false);

                        // Inserisco i componenti
                        L_RProdOrdComp.SetRange(Status, V_RProdOrderLine.Status);
                        L_RProdOrdComp.SetRange("Prod. Order No.", V_RProdOrderLine."Prod. Order No.");
                        L_RProdOrdComp.SetRange("Prod. Order Line No.", V_RProdOrderLine."Line No.");
                        if L_RProdOrdComp.FindSet() then
                            repeat
                                // Escludo Item Category:
                                //      IMBALLO
                                if not L_RItem.Get(L_RProdOrdComp."Item No.") then
                                    Clear(L_RItem);
                                //TODO capire se escludere comunque l'Item category code IMBALLO e nel caso mettere un campo a Setup
                                if not (L_RItem."Item Category Code" in ['IMBALLO']) then begin
                                    V_RTMPSubcFeas1.Init();
                                    V_RTMPSubcFeas1.TransferFields(L_RProdOrdComp);
                                    V_RTMPSubcFeas1."Component Description" := L_RItem.Description;
                                    V_RTMPSubcFeas1."Planning Group" := L_RItem."Planning Group FLE";
                                    V_RTMPSubcFeas1."Internal Location" := V_RProdOrderLine."Location Code";
                                    //TODO External location potrebbe cambiare se i componenti vengono consumanti su 2 fasi del ciclo diverse e queste fasi sono esterne da terzisti diversi
                                    //TODO perciò questo campo valorizzato qui non va bene e di conseguenza anche il campo in testata non va bene  V_RTMPSubcFeas."Subcontracting Location Code"
                                    V_RTMPSubcFeas1."External Location" := V_RTMPSubcFeas."Subcontracting Location Code";
                                    V_RTMPSubcFeas1."Expected Receipt Qty. (Base)" := F_GetExpectedReceiptQty(V_RTMPSubcFeas1."Item No.", V_RTMPSubcFeas1."Variant Code", V_RTMPSubcFeas1."Internal Location");
                                    F_CalcTotalInternalAndExternalComponentInventory(V_RTMPSubcFeas, V_RTMPSubcFeas1);
                                    //Trovo la fase di prelievo del componente. 
                                    if (L_RProdOrdRoutL."Prod. Order No." <> V_RProdOrderLine."Prod. Order No.") or
                                       (L_RProdOrdRoutL."Routing Link Code" <> L_RProdOrdComp."Routing Link Code") then begin
                                        L_RProdOrdRoutL.SetRange("Routing Link Code", V_RTMPSubcFeas1."Routing Link Code");
                                        if not L_RProdOrdRoutL.FindFirst() then
                                            Clear(L_RProdOrdRoutL);
                                    end;
                                    // Calcolo le qtà di giacenza interna ed esterna già utilizzate e utilizzabili dal componente per l'ordine di produzione in modo da capire se le giacenze sono sufficienti per la realizzazione dell'ODP
                                    F_CalculateUsedAndUsableQuantitiesForComponent(V_RTMPSubcFeas1, L_RProdOrdRoutL, L_RProdOrdComp);

                                    if (V_RTMPSubcFeas1."Int. Reserved Quantity (Base)" = 0) and (V_RTMPSubcFeas1."Subc. Reserved Quantity (Base)" = 0) then
                                        V_RTMPSubcFeas1."Not Feasible" := true;
                                    if ((V_RTMPSubcFeas1."Int. Reserved Quantity (Base)" > 0) and (V_RTMPSubcFeas1."Int. Reserved Quantity (Base)" < V_RTMPSubcFeas1."Remaining Qty. (Base)")) or
                                       ((V_RTMPSubcFeas1."Subc. Reserved Quantity (Base)" > 0) and (V_RTMPSubcFeas1."Subc. Reserved Quantity (Base)" < V_RTMPSubcFeas1."Remaining Qty. (Base)")) then
                                        V_RTMPSubcFeas1."Partially Feasible" := true;
                                    V_RTMPSubcFeas1.Insert(false);

                                    //Calcolo quantità fattibile dell'articolo finito da mostrare in testata
                                    //L_ProdOrderComponentInternalFeasableQty contiene quanti articoli finiti riesco a fare con il componente in base alla giacenza interna
                                    L_ComponentInternalFeasableQty := F_ConvertComponentQtyToProdOrderFinishedQty(V_RTMPSubcFeas1."Int. Reserved Quantity (Base)",
                                                                                                                  V_RTMPSubcFeas1."Quantity per",
                                                                                                                  V_RTMPSubcFeas1."Qty. per Unit of Measure");

                                    //L_ProdOrderComponentSubcontractorFeasableQty contiene quanti articoli finiti riesco a fare con il componente in base alla giacenza esterna
                                    L_ComponentSubcontractorFeasableQty := F_ConvertComponentQtyToProdOrderFinishedQty(V_RTMPSubcFeas1."Subc. Reserved Quantity (Base)",
                                                                                                                       V_RTMPSubcFeas1."Quantity per",
                                                                                                                       V_RTMPSubcFeas1."Qty. per Unit of Measure");
                                    case true of
                                        //In testata mostro sempre la quantità fattibile minima tra tutti i componenti
                                        (L_ComponentInternalFeasableQty + L_ComponentSubcontractorFeasableQty) < L_TotalComponentFeasableQty:
                                            begin
                                                L_TotalComponentFeasableQty := L_ComponentInternalFeasableQty + L_ComponentSubcontractorFeasableQty;
                                                L_ProdOrderSubcontractorFeasableQty := L_ComponentSubcontractorFeasableQty;
                                                L_ProdOrderInternalFeasableQty := L_ComponentInternalFeasableQty;
                                            end;
                                        //Questa opzione serve solo per gestire i casi di conto lavoro: se 2 o più componenti hanno la stessa quantità fattibile totale, scelgo quello che ha la quantità fattibile in conto lavoro minore (quindi più qtà da trasferire).
                                        (L_ComponentInternalFeasableQty + L_ComponentSubcontractorFeasableQty) = L_TotalComponentFeasableQty:
                                            begin
                                                if L_ComponentSubcontractorFeasableQty < L_ProdOrderSubcontractorFeasableQty then begin
                                                    L_ProdOrderSubcontractorFeasableQty := L_ComponentSubcontractorFeasableQty;
                                                    L_ProdOrderInternalFeasableQty := L_ComponentInternalFeasableQty;
                                                end;
                                            end;
                                    end;
                                end;
                            until L_RProdOrdComp.Next() = 0;

                        //Quantità fattibile in conto lavoro
                        V_RTMPSubcFeas."Subc. Feasible Quantity (Base)" := L_ProdOrderSubcontractorFeasableQty;
                        //Quantità fattibile internamente
                        V_RTMPSubcFeas."Int. Feasible Quantity (Base)" := L_ProdOrderInternalFeasableQty;
                        //Booleano che dice se fattibile completamente esternamente
                        V_RTMPSubcFeas."Full Feasible SubC" := V_RTMPSubcFeas."Operation Rem. Qty. (Base)" <= V_RTMPSubcFeas."Subc. Feasible Quantity (Base)";
                        //Se "TS Feasible Quantity (Base)" è maggiore della Remaining qty allora pareggio le qtà diminuendo la qtà fattibile interna
                        //Questo può essere dovuto dai tassi di conversione sui componenti che potrebbero far differire le qtà di qualche decimale
                        if (V_RTMPSubcFeas."Subc. Feasible Quantity (Base)" + V_RTMPSubcFeas."Int. Feasible Quantity (Base)") > V_RTMPSubcFeas."Operation Rem. Qty. (Base)" then
                            V_RTMPSubcFeas."Int. Feasible Quantity (Base)" -= (V_RTMPSubcFeas."Subc. Feasible Quantity (Base)" + V_RTMPSubcFeas."Int. Feasible Quantity (Base)") - V_RTMPSubcFeas."Operation Rem. Qty. (Base)";
                        if (V_RTMPSubcFeas.Subcontractor <> '') and
                           (not V_RTMPSubcFeas."Full Feasible SubC") and
                           (V_RTMPSubcFeas."Int. Feasible Quantity (Base)" > 0) then
                            //Indica la qtà totale fattibile tra quantità fattibile esternamente e internamente
                            V_RTMPSubcFeas."TS Feasible Quantity (Base)" := V_RTMPSubcFeas."Subc. Feasible Quantity (Base)" + V_RTMPSubcFeas."Int. Feasible Quantity (Base)";
                        if V_RTMPSubcFeas."TS Feasible Quantity (Base)" > 0 then
                            //Indica se conto lavoro è completamente fattibile tramite trasferimento di giacenza interna
                            V_RTMPSubcFeas."Full Feasible Transfer" := V_RTMPSubcFeas."Operation Rem. Qty. (Base)" <= V_RTMPSubcFeas."TS Feasible Quantity (Base)";
                        //Indica se completamente fattibile
                        V_RTMPSubcFeas."Full Feasible" := (V_RTMPSubcFeas."Operation Rem. Qty. (Base)" <= V_RTMPSubcFeas."Int. Feasible Quantity (Base)") or
                                                          (V_RTMPSubcFeas."Full Feasible SubC") or
                                                          (V_RTMPSubcFeas."Full Feasible Transfer");
                        //Mi salvo se l'ordine di produzione è parzialmente fattibile
                        if (not V_RTMPSubcFeas."Full Feasible") and (not V_RTMPSubcFeas."Full Feasible SubC") and (not V_RTMPSubcFeas."Full Feasible Transfer") then
                            if (V_RTMPSubcFeas."Int. Feasible Quantity (Base)" > 0) or (V_RTMPSubcFeas."Subc. Feasible Quantity (Base)" > 0) then
                                V_RTMPSubcFeas."Partially Feasible" := true;
                        V_RTMPSubcFeas.Modify(false);//TODO vedere se qui fare il modify oppure spostare l'insert che c'è sopra e metterlo qui

                        if (V_RTMPSubcFeas."Partially Feasible") or (not V_RTMPSubcFeas."Full Feasible") then
                            if BCalcReservationBasedOnMaxFeasibleQty then
                                F_RecalcUsedAndUsableQuantitiesForComponentForNotFullyFeasbleOrder(V_RProdOrderLine,
                                                                                                   V_RTMPSubcFeas1,
                                                                                                   V_RTMPSubcFeas);
                    end;
                end;
            until V_RProdOrderLine.Next() = 0;
            if GuiAllowed then
                L_CConfigProgressBar.Close();
        end;
    end;

    /// <summary>
    /// Calcola le quantità di giacenza interna ed esterna relative al componente di un ordine di produzione.
    /// Per ogni componente viene determinata:
    /// - la quantità già utilizzata (interna ed esterna) (impegnata in altri ordini),
    /// - la quantità ancora utilizzabile (interna ed esterna) (disponibile a magazzino o presso fornitori).
    /// </summary>
    local procedure F_CalculateUsedAndUsableQuantitiesForComponent(var V_RTempSubcFeasibility1: Record "TMP Subc. Feasibility 1 PTE" temporary; P_RProdOrderRoutingLine: Record "Prod. Order Routing Line"; var V_RProdOrderComponent: Record "Prod. Order Component")
    var
        L_ExternalInventoryAlreadyUsed: Decimal;
        L_ExternalInventoryCanBeUsed: Decimal;
        L_InternalInventoryAlreadyUsed: Decimal;
        L_InternalInventoryCanBeUsed: Decimal;
        L_QuantityOverExternalInventory: Decimal; //Conterrà la quantità rimanente che la giacenza esterna non riuscirà a coprire e dovrà essere coperta da quella interna (se presente)
        L_ComponentKey: Code[30];
        L_VendorNo: Code[20];
        L_InternalComponentInventoryAlreadyUsed, L_ExternalComponentInventoryAlreadyUsed : Dictionary of [Code[30], Decimal];
        L_ProdOrderNoForDrillDownIntQtyUsedByOther: Dictionary of [Code[20], Dictionary of [Code[10], List of [Code[20]]]];
        L_ProdOrderString: Text;
        L_OriginalRemainingQty, L_ComponentQtyInTransferOrder : Decimal;
        L_QtyInTransferOrderPerComponent: Dictionary of [Code[30], Decimal];
        L_MaxProdOrderFeasibleQty: Decimal;
    begin
        L_ExternalInventoryAlreadyUsed := 0;
        L_ExternalInventoryCanBeUsed := 0;
        L_InternalInventoryAlreadyUsed := 0;
        L_InternalInventoryCanBeUsed := 0;
        L_QuantityOverExternalInventory := 0;
        L_ComponentKey := F_GetComponentKey(V_RTempSubcFeasibility1."Item No.", V_RTempSubcFeasibility1."Variant Code");
        L_VendorNo := F_GetVendorFromProdOrderRoutingLine(P_RProdOrderRoutingLine);

        //Salvo la qtà rimanente perché nel campo V_RTempSubcFeasibility1."Remaining Qty. (Base)", se il componente è esterno, inserisco la qtà che la giacenza esterna del fornitore non riesce a coprire
        L_OriginalRemainingQty := V_RTempSubcFeasibility1."Remaining Qty. (Base)";

        //Se la fase del ciclo è esterna utilizzo prima la giacenza esterna
        if P_RProdOrderRoutingLine."External Operation FLE" then begin
            if TotalExternalInventoryAlreadyUsed.Get(L_VendorNo, L_ExternalComponentInventoryAlreadyUsed) then begin
                if L_ExternalComponentInventoryAlreadyUsed.Get(L_ComponentKey, L_ExternalInventoryAlreadyUsed) then begin
                    //Controllo se la giacenza esterna GIÀ UTILIZZATA + la qtà rimanente è superiore della giacenza esterna TOTALE in modo da sapere se devo utilizzare la giacenza interna
                    if (L_ExternalInventoryAlreadyUsed + V_RTempSubcFeasibility1."Remaining Qty. (Base)") > V_RTempSubcFeasibility1."External Inventory" then begin
                        L_ExternalComponentInventoryAlreadyUsed.Set(L_ComponentKey, V_RTempSubcFeasibility1."External Inventory");
                        //Calcolo quanta qtà rimanente deve essere coperta dalla giacenza interna in quanto quella esterna TOTALE non copre la totalità della qtà rimanente 
                        if L_ExternalInventoryAlreadyUsed < V_RTempSubcFeasibility1."External Inventory" then
                            //Se la giacenza esterna GIÀ UTILIZZATA è minore della giacenza esterna TOTALE vuol dire che una parte di qtà rimanente può essere coperta dalla giacenza esterna, il restante da quella interna
                            L_QuantityOverExternalInventory := (L_ExternalInventoryAlreadyUsed + V_RTempSubcFeasibility1."Remaining Qty. (Base)") - V_RTempSubcFeasibility1."External Inventory"
                        else
                            //Se la giacenza esterna GIÀ UTILIZZATA è uguale o maggiore della giacenza esterna TOTALE vuol dire che tutta la qtà rimanente dovrà essere coperta dalla giacenza interna
                            L_QuantityOverExternalInventory := V_RTempSubcFeasibility1."Remaining Qty. (Base)";
                    end else
                        L_ExternalComponentInventoryAlreadyUsed.Set(L_ComponentKey, (L_ExternalInventoryAlreadyUsed + V_RTempSubcFeasibility1."Remaining Qty. (Base)"));
                end else begin
                    //! parte uguale a quella sotto, vedere se si riesce a cambiare in modo da non avere codice duplicato. Da qui
                    if V_RTempSubcFeasibility1."Remaining Qty. (Base)" > V_RTempSubcFeasibility1."External Inventory" then begin
                        L_ExternalComponentInventoryAlreadyUsed.Add(L_ComponentKey, V_RTempSubcFeasibility1."External Inventory");
                        L_QuantityOverExternalInventory := V_RTempSubcFeasibility1."Remaining Qty. (Base)" - V_RTempSubcFeasibility1."External Inventory";
                    end else
                        L_ExternalComponentInventoryAlreadyUsed.Add(L_ComponentKey, V_RTempSubcFeasibility1."Remaining Qty. (Base)");
                    //! fino a qui
                end;
                TotalExternalInventoryAlreadyUsed.Set(L_VendorNo, L_ExternalComponentInventoryAlreadyUsed);
            end else begin
                //! parte uguale a quella sopra, vedere se si riesce a cambiare in modo da non avere codice duplicato. Da qui
                if V_RTempSubcFeasibility1."Remaining Qty. (Base)" > V_RTempSubcFeasibility1."External Inventory" then begin
                    L_ExternalComponentInventoryAlreadyUsed.Add(L_ComponentKey, V_RTempSubcFeasibility1."External Inventory");
                    L_QuantityOverExternalInventory := V_RTempSubcFeasibility1."Remaining Qty. (Base)" - V_RTempSubcFeasibility1."External Inventory";
                end else
                    L_ExternalComponentInventoryAlreadyUsed.Add(L_ComponentKey, V_RTempSubcFeasibility1."Remaining Qty. (Base)");
                //! fino a qui

                TotalExternalInventoryAlreadyUsed.Add(L_VendorNo, L_ExternalComponentInventoryAlreadyUsed);
            end;

            //Calcolo la giacenza esterna utilizzabile per il componente suddivsa per terzista
            L_ExternalInventoryCanBeUsed := V_RTempSubcFeasibility1."External Inventory" - L_ExternalInventoryAlreadyUsed;
            if L_ExternalInventoryCanBeUsed > 0 then begin
                if L_ExternalInventoryCanBeUsed >= V_RTempSubcFeasibility1."Remaining Qty. (Base)" then
                    L_ExternalInventoryCanBeUsed := V_RTempSubcFeasibility1."Remaining Qty. (Base)";
            end else
                L_ExternalInventoryCanBeUsed := 0;

            V_RTempSubcFeasibility1."Subc. Qty. used Other (Base)" := L_ExternalInventoryAlreadyUsed;
            V_RTempSubcFeasibility1."Subc. Reserved Quantity (Base)" := L_ExternalInventoryCanBeUsed;

            //Calcolo il dizionario che serve per drill down sulla qtà ESTERNA del componente già usata da altri (page "Subcontactor Feasibility 1 PTE")
            L_ProdOrderString := '';
            if V_RTempSubcFeasibility1."Subc. Qty. used Other (Base)" > 0 then
                if F_GetEntryFromProdOrderDictionary(L_ProdOrderString, ProdOrderNoForDrillDownExternalQtyUsedByOther, V_RTempSubcFeasibility1, V_RTempSubcFeasibility1."External Location") then
                    F_AddEntryInProdOrderDictionaryPerProdOrder(ProdOrderNoForDrillDownExternalQtyUsedByOtherPerProdOrder, V_RTempSubcFeasibility1, L_ProdOrderString, V_RTempSubcFeasibility1."External Location");
            if (V_RTempSubcFeasibility1."Remaining Qty. (Base)" > 0) and (V_RTempSubcFeasibility1."External Inventory" > V_RTempSubcFeasibility1."Subc. Qty. used Other (Base)") then
                F_AddEntryInProdOrderDictionary(ProdOrderNoForDrillDownExternalQtyUsedByOther, V_RTempSubcFeasibility1, V_RTempSubcFeasibility1."External Location");

            //Sostituisco la qtà rimanente con la qtà che la giacenza esterna non riesce a coprire perchè sarà la qtà che deve essere coperta dalla qtà interna
            V_RTempSubcFeasibility1."Remaining Qty. (Base)" := L_QuantityOverExternalInventory;
        end;

        //Calcolo la giacenza interna già utilizzata per il componente suddivsa per ubicazione
        if TotalInternalInventoryAlreadyUsed.Get(V_RTempSubcFeasibility1."Internal Location", L_InternalComponentInventoryAlreadyUsed) then begin
            if L_InternalComponentInventoryAlreadyUsed.Get(L_ComponentKey, L_InternalInventoryAlreadyUsed) then begin
                if (L_InternalInventoryAlreadyUsed + V_RTempSubcFeasibility1."Remaining Qty. (Base)") > V_RTempSubcFeasibility1."Internal Inventory" then
                    L_InternalComponentInventoryAlreadyUsed.Set(L_ComponentKey, V_RTempSubcFeasibility1."Internal Inventory")
                else
                    L_InternalComponentInventoryAlreadyUsed.Set(L_ComponentKey, (L_InternalInventoryAlreadyUsed + V_RTempSubcFeasibility1."Remaining Qty. (Base)"));
            end else begin
                //! parte uguale a quella sopra, vedere se si riesce a cambiare in modo da non avere codice duplicato. Da qui
                if V_RTempSubcFeasibility1."Remaining Qty. (Base)" > V_RTempSubcFeasibility1."Internal Inventory" then
                    L_InternalComponentInventoryAlreadyUsed.Add(L_ComponentKey, V_RTempSubcFeasibility1."Internal Inventory")
                else
                    L_InternalComponentInventoryAlreadyUsed.Add(L_ComponentKey, V_RTempSubcFeasibility1."Remaining Qty. (Base)");
                //! fino a qui
            end;
            TotalInternalInventoryAlreadyUsed.Set(V_RTempSubcFeasibility1."Internal Location", L_InternalComponentInventoryAlreadyUsed);
        end else begin
            //! parte uguale a quella sopra, vedere se si riesce a cambiare in modo da non avere codice duplicato. Da qui
            if V_RTempSubcFeasibility1."Remaining Qty. (Base)" > V_RTempSubcFeasibility1."Internal Inventory" then
                L_InternalComponentInventoryAlreadyUsed.Add(L_ComponentKey, V_RTempSubcFeasibility1."Internal Inventory")
            else
                L_InternalComponentInventoryAlreadyUsed.Add(L_ComponentKey, V_RTempSubcFeasibility1."Remaining Qty. (Base)");
            //! fino a qui
            TotalInternalInventoryAlreadyUsed.Add(V_RTempSubcFeasibility1."Internal Location", L_InternalComponentInventoryAlreadyUsed);
        end;

        //Calcolo la giacenza interna utilizzabile per il componente suddivsa per ubicazione
        L_InternalInventoryCanBeUsed := V_RTempSubcFeasibility1."Internal Inventory" - L_InternalInventoryAlreadyUsed;
        if L_InternalInventoryCanBeUsed > 0 then begin
            if L_InternalInventoryCanBeUsed >= V_RTempSubcFeasibility1."Remaining Qty. (Base)" then
                L_InternalInventoryCanBeUsed := V_RTempSubcFeasibility1."Remaining Qty. (Base)";
        end else
            L_InternalInventoryCanBeUsed := 0;
        V_RTempSubcFeasibility1."Int. Qty. used Other (Base)" := L_InternalInventoryAlreadyUsed;
        V_RTempSubcFeasibility1."Int. Reserved Quantity (Base)" := L_InternalInventoryCanBeUsed;

        //Calcolo il dizionario che serve per drill down sulla qtà INTERNA del componente già usata da altri (page "Subcontactor Feasibility 1 PTE")
        L_ProdOrderString := '';
        if V_RTempSubcFeasibility1."Int. Qty. used Other (Base)" > 0 then
            if F_GetEntryFromProdOrderDictionary(L_ProdOrderString, ProdOrderNoForDrillDownInternalQtyUsedByOther, V_RTempSubcFeasibility1, V_RTempSubcFeasibility1."Internal Location") then
                F_AddEntryInProdOrderDictionaryPerProdOrder(ProdOrderNoForDrillDownInternalQtyUsedByOtherPerProdOrder, V_RTempSubcFeasibility1, L_ProdOrderString, V_RTempSubcFeasibility1."Internal Location");
        if (V_RTempSubcFeasibility1."Remaining Qty. (Base)" > 0) and (V_RTempSubcFeasibility1."Internal Inventory" > V_RTempSubcFeasibility1."Int. Qty. used Other (Base)") then
            F_AddEntryInProdOrderDictionary(ProdOrderNoForDrillDownInternalQtyUsedByOther, V_RTempSubcFeasibility1, V_RTempSubcFeasibility1."Internal Location");

        //Imposto nuovamente la qtà rimanente originale
        V_RTempSubcFeasibility1."Remaining Qty. (Base)" := L_OriginalRemainingQty;
    end;

    local procedure F_GetInternalQtyAlreadyUsedForComponent(var V_InternalQty: Decimal; L_InternalLocationCode: Code[10]; P_ComponentKey: code[30]): Boolean
    var
        L_InternalComponentInventoryAlreadyUsed: Dictionary of [Code[30], Decimal];
    begin
        V_InternalQty := 0;
        if not TotalInternalInventoryAlreadyUsed.Get(L_InternalLocationCode, L_InternalComponentInventoryAlreadyUsed) then
            exit(false);
        if not L_InternalComponentInventoryAlreadyUsed.Get(P_ComponentKey, V_InternalQty) then
            exit(false);
        exit(true);
    end;

    local procedure F_GetExternalQtyAlreadyUsedForComponent(var V_ExternalQty: Decimal; L_VendorNo: Code[20]; P_ComponentKey: code[30]): Boolean
    var
        L_ExternalComponentInventoryAlreadyUsed: Dictionary of [Code[30], Decimal];
    begin
        V_ExternalQty := 0;
        if not TotalExternalInventoryAlreadyUsed.Get(L_VendorNo, L_ExternalComponentInventoryAlreadyUsed) then
            exit(false);
        if not L_ExternalComponentInventoryAlreadyUsed.Get(P_ComponentKey, V_ExternalQty) then
            exit(false);
        exit(true);
    end;

    ///<summary>Passando la qtà del componente restituisce la qtà di finiti si riescono a fare</summary>
    local procedure F_ConvertComponentQtyToProdOrderFinishedQty(P_ComponentQty: Decimal; P_QtyPer: Decimal; P_QtyPerUnitOfMeasure: Decimal): Decimal
    begin
        if P_ComponentQty = 0 then
            exit(0);
        exit(Round(P_ComponentQty / (P_QtyPer * P_QtyPerUnitOfMeasure), 0.001, '>'));
    end;

    ///<summary>Passando la qtà dell'ordine di produzione restituisce la qtà del componente per farlo</summary>
    local procedure F_ConvertProdOrderFinishedQtyToComponentQty(P_ProdOrderQtyQty: Decimal; P_QtyPer: Decimal; P_QtyPerUnitOfMeasure: Decimal): Decimal
    begin
        if P_ProdOrderQtyQty = 0 then
            exit(0);
        exit(Round(P_ProdOrderQtyQty * (P_QtyPer * P_QtyPerUnitOfMeasure), 0.001, '>'));
    end;

    local procedure F_RecalcUsedAndUsableQuantitiesForComponentForNotFullyFeasbleOrder(P_RProdOrderLine: Record "Prod. Order Line"; var V_RTempSubcFeasibility1: Record "TMP Subc. Feasibility 1 PTE" temporary; P_RTMPSubcFeas: Record "TMP Subc. Feasibility PTE" temporary)
    var
        L_RTempSubcFeasibility1: Record "TMP Subc. Feasibility 1 PTE" temporary;
        L_FeasibleQty: Decimal;
        L_ComponentFeasibleQty: Decimal;
        L_InternalComponentInventoryAlreadyUsed, L_ExternalComponentInventoryAlreadyUsed : Dictionary of [Code[30], Decimal];
        L_RProdOrderRoutingLine: Record "Prod. Order Routing Line";
        L_VendorNo: Code[20];
        L_ComponentKey: Code[30];
        L_InternalQtyToRemove, L_ExternalQtyToRemove : Decimal;
        L_OriginalReservedInternalQty, L_OriginalReservedExternalQty : Decimal;
    begin
        L_FeasibleQty := P_RTMPSubcFeas."Int. Feasible Quantity (Base)" + P_RTMPSubcFeas."Subc. Feasible Quantity (Base)";
        L_RTempSubcFeasibility1.Copy(V_RTempSubcFeasibility1, true);
        CGeneralManufacturing.FilterProdOrderRoutingLineFromProdOrderLine(L_RProdOrderRoutingLine, P_RProdOrderLine);
        L_RTempSubcFeasibility1.Reset();
        L_RTempSubcFeasibility1.SetRange("Prod. Order No.");
        L_RTempSubcFeasibility1.SetRange(Status, P_RTMPSubcFeas.Status);
        L_RTempSubcFeasibility1.SetRange("Prod. Order No.", P_RTMPSubcFeas."Prod. Order No.");
        L_RTempSubcFeasibility1.SetRange("Prod. Order Line No.", P_RTMPSubcFeas."Line No.");
        if L_RTempSubcFeasibility1.FindSet() then
            repeat
                L_ComponentKey := F_GetComponentKey(L_RTempSubcFeasibility1."Item No.", L_RTempSubcFeasibility1."Variant Code");
                L_OriginalReservedInternalQty := L_RTempSubcFeasibility1."Int. Reserved Quantity (Base)";
                L_OriginalReservedExternalQty := L_RTempSubcFeasibility1."Subc. Reserved Quantity (Base)";
                if L_FeasibleQty = 0 then begin
                    // if L_RTempSubcFeasibility1."External Location" <> '' then begin
                    //     L_RProdOrderRoutingLine.SetRange("Routing Link Code", L_RTempSubcFeasibility1."Routing Link Code");
                    //     if L_RProdOrderRoutingLine.FindFirst() then begin
                    //         L_VendorNo := F_GetVendorFromProdOrderRoutingLine(L_RProdOrderRoutingLine);
                    //         if TotalExternalInventoryAlreadyUsed.Get(L_VendorNo, L_ExternalComponentInventoryAlreadyUsed) then
                    //             if L_ExternalComponentInventoryAlreadyUsed.Get(L_ComponentKey, L_ExternalInventoryAlreadyUsed) then begin
                    //                 L_ExternalComponentInventoryAlreadyUsed.Set(L_ComponentKey, 0);
                    //                 TotalExternalInventoryAlreadyUsed.Set(L_VendorNo, L_ExternalComponentInventoryAlreadyUsed);
                    //             end;
                    //     end;
                    // end;
                    // if TotalInternalInventoryAlreadyUsed.Get(L_RTempSubcFeasibility1."Internal Location", L_InternalComponentInventoryAlreadyUsed) then
                    //     if L_InternalComponentInventoryAlreadyUsed.Get(L_ComponentKey, L_ExternalInventoryAlreadyUsed) then begin
                    //         L_InternalComponentInventoryAlreadyUsed.Set(L_ComponentKey, 0);
                    //         TotalInternalInventoryAlreadyUsed.Set(L_VendorNo, L_InternalComponentInventoryAlreadyUsed);
                    //     end;
                    F_UpdateInventoryAlreadyUsedDictionary(P_RProdOrderLine,
                                                           L_RTempSubcFeasibility1."External Location",
                                                           L_RTempSubcFeasibility1."Internal Location",
                                                           L_RTempSubcFeasibility1."Routing Link Code",
                                                           L_RTempSubcFeasibility1."Item No.",
                                                           L_RTempSubcFeasibility1."Variant Code",
                                                           L_RTempSubcFeasibility1."Int. Reserved Quantity (Base)",
                                                           L_RTempSubcFeasibility1."Subc. Reserved Quantity (Base)");
                    L_RTempSubcFeasibility1."Subc. Reserved Quantity (Base)" := 0;
                    L_RTempSubcFeasibility1."Int. Reserved Quantity (Base)" := 0;
                end else begin

                    //TODO Teoricamente ora funziona tutto, fare prove ma dovrebbe essere ok (ODP WO24023073) (fatto un pò di controlli e sembra andare bene)
                    //TODO Fare come in plastiape che si può inserire una data sull'ordine di produzione e te lo sposta o prima o dopo
                    //TODO sistemare campo nella sezione filtri + vedi altre azioni e campi da sistemare + TODO sotto

                    L_ComponentFeasibleQty := F_ConvertProdOrderFinishedQtyToComponentQty(L_FeasibleQty,
                                                                                          L_RTempSubcFeasibility1."Quantity per",
                                                                                          L_RTempSubcFeasibility1."Qty. per Unit of Measure");
                    if L_RTempSubcFeasibility1."External Location" <> '' then begin
                        if (L_RTempSubcFeasibility1."External Inventory" - L_RTempSubcFeasibility1."Subc. Qty. used Other (Base)") > L_ComponentFeasibleQty then begin
                            L_RTempSubcFeasibility1."Subc. Reserved Quantity (Base)" := L_ComponentFeasibleQty;
                            L_ComponentFeasibleQty := 0;
                        end else begin
                            L_RTempSubcFeasibility1."Subc. Reserved Quantity (Base)" := (L_RTempSubcFeasibility1."External Inventory" - L_RTempSubcFeasibility1."Subc. Qty. used Other (Base)");
                            L_ComponentFeasibleQty -= (L_RTempSubcFeasibility1."External Inventory" - L_RTempSubcFeasibility1."Subc. Qty. used Other (Base)");
                        end;
                        L_ExternalQtyToRemove := L_RTempSubcFeasibility1."Subc. Reserved Quantity (Base)" - (L_OriginalReservedExternalQty - L_ComponentFeasibleQty);
                        if L_ExternalQtyToRemove < 0 then
                            L_ExternalQtyToRemove := 0;
                    end;
                    if L_ComponentFeasibleQty > 0 then
                        if (L_RTempSubcFeasibility1."Internal Inventory" - L_RTempSubcFeasibility1."Int. Qty. used Other (Base)") > L_ComponentFeasibleQty then
                            L_RTempSubcFeasibility1."Int. Reserved Quantity (Base)" := L_ComponentFeasibleQty
                        else
                            //Teoricamente L_ComponentFeasibleQty non può esser maggiore di L_RTempSubcFeasibility1."Int. Reserved Quantity (Base)"
                            L_RTempSubcFeasibility1."Int. Reserved Quantity (Base)" := (L_RTempSubcFeasibility1."Internal Inventory" - L_RTempSubcFeasibility1."Int. Qty. used Other (Base)");
                    L_InternalQtyToRemove := L_RTempSubcFeasibility1."Int. Reserved Quantity (Base)" - (L_OriginalReservedInternalQty - L_ComponentFeasibleQty);
                    if L_InternalQtyToRemove < 0 then
                        L_InternalQtyToRemove := 0;

                    F_UpdateInventoryAlreadyUsedDictionary(P_RProdOrderLine,
                                                           L_RTempSubcFeasibility1."External Location",
                                                           L_RTempSubcFeasibility1."Internal Location",
                                                           L_RTempSubcFeasibility1."Routing Link Code",
                                                           L_RTempSubcFeasibility1."Item No.",
                                                           L_RTempSubcFeasibility1."Variant Code",
                                                           L_InternalQtyToRemove,
                                                           L_ExternalQtyToRemove);
                end;
                L_RTempSubcFeasibility1.Modify(false);
            until L_RTempSubcFeasibility1.Next() = 0;
        //Aggiorno i dizionari che contengono in quali ordini di produzione è stata utilizzata la giacenza interna ed esterna del componente per fare i drill down
        if L_FeasibleQty = 0 then begin
            //Se la qtà fattibile è 0 rimuovo l'ODP dai dizionari in quanto non ha utilizzato giacenza interna
            ProdOrderNoForDrillDownInternalQtyUsedByOtherPerProdOrder.Remove(P_RTMPSubcFeas."Prod. Order No." + Format(P_RTMPSubcFeas."Line No."));
            //Se la qtà fattibile è 0 rimuovo l'ODP dai dizionari in quanto non ha utilizzato giacenza esterna
            ProdOrderNoForDrillDownExternalQtyUsedByOtherPerProdOrder.Remove(P_RTMPSubcFeas."Prod. Order No." + Format(P_RTMPSubcFeas."Line No."));
        end;
    end;

    local procedure F_UpdateInventoryAlreadyUsedDictionary(P_RProdOrderLine: Record "Prod. Order Line"; P_ExternalLocation: Code[10]; P_InternalLocation: Code[10]; P_RoutingLinkCode: Code[10]; P_ItemNo: Code[20]; P_VariantCode: Code[10]; P_NewInternalQty: Decimal; P_NewExternalQty: Decimal)
    var
        L_RProdOrderRoutingLine: Record "Prod. Order Routing Line";
        L_VendorNo: Code[20];
        L_ExternalInventoryAlreadyUsed, L_InternalInventoryAlreadyUsed : Decimal;
        L_InternalComponentInventoryAlreadyUsed, L_ExternalComponentInventoryAlreadyUsed : Dictionary of [Code[30], Decimal];
    begin
        if P_ExternalLocation <> '' then begin
            CGeneralManufacturing.FilterProdOrderRoutingLineFromProdOrderLine(L_RProdOrderRoutingLine, P_RProdOrderLine);
            L_RProdOrderRoutingLine.SetRange("Routing Link Code", P_RoutingLinkCode);
            if L_RProdOrderRoutingLine.FindFirst() then
                L_VendorNo := F_GetVendorFromProdOrderRoutingLine(L_RProdOrderRoutingLine);
        end;
        F_UpdateInventoryAlreadyUsedDictionary(P_ExternalLocation, P_InternalLocation, L_VendorNo, P_ItemNo, P_VariantCode, P_NewInternalQty, P_NewExternalQty);
    end;

    local procedure F_UpdateInventoryAlreadyUsedDictionary(P_ExternalLocation: Code[10]; P_InternalLocation: Code[10]; P_VendorNo: Code[20]; P_ItemNo: Code[20]; P_VariantCode: Code[10]; P_InternalQtyToRemove: Decimal; P_ExternalQtyToRemove: Decimal)
    var
        L_RProdOrderRoutingLine: Record "Prod. Order Routing Line";
        L_ComponentKey: Code[30];
        L_ExternalInventoryAlreadyUsed, L_InternalInventoryAlreadyUsed : Decimal;
        L_InternalComponentInventoryAlreadyUsed, L_ExternalComponentInventoryAlreadyUsed : Dictionary of [Code[30], Decimal];
    begin
        L_ComponentKey := F_GetComponentKey(P_ItemNo, P_VariantCode);
        if P_ExternalLocation <> '' then begin
            if TotalExternalInventoryAlreadyUsed.Get(P_VendorNo, L_ExternalComponentInventoryAlreadyUsed) then
                if L_ExternalComponentInventoryAlreadyUsed.Get(L_ComponentKey, L_ExternalInventoryAlreadyUsed) then begin
                    L_ExternalComponentInventoryAlreadyUsed.Set(L_ComponentKey, L_ExternalInventoryAlreadyUsed - P_ExternalQtyToRemove);
                    TotalExternalInventoryAlreadyUsed.Set(P_VendorNo, L_ExternalComponentInventoryAlreadyUsed);
                end;
        end;
        if TotalInternalInventoryAlreadyUsed.Get(P_InternalLocation, L_InternalComponentInventoryAlreadyUsed) then
            if L_InternalComponentInventoryAlreadyUsed.Get(L_ComponentKey, L_InternalInventoryAlreadyUsed) then begin
                L_InternalComponentInventoryAlreadyUsed.Set(L_ComponentKey, L_InternalInventoryAlreadyUsed - P_InternalQtyToRemove);
                TotalInternalInventoryAlreadyUsed.Set(P_InternalLocation, L_InternalComponentInventoryAlreadyUsed);
            end;
    end;

    // // local procedure F_CalcFeasibleQtyForProdOrder(P_ProdOrderRemainingQty: Decimal; P_VendorNo: Code[20]; P_RTempSubcFeasibility1: Record "TMP Subc. Feasibility 1 PTE" temporary; var V_RProdOrderComponent: Record "Prod. Order Component") O_ComponentQty: Decimal
    // local procedure F_CalcFeasibleQtyForProdOrder(P_ProdOrderRemainingQty: Decimal; P_VendorNo: Code[20]; var V_RProdOrderComponent: Record "Prod. Order Component") O_ComponentQty: Decimal
    // var
    //     L_InternalInventoryAlreadyUsed, L_ExternalInventoryAlreadyUsed : Decimal;
    //     L_InternalComponentInventoryAlreadyUsed, L_ExternalComponentInventoryAlreadyUsed : Dictionary of [Code[30], Decimal];
    //     L_ComponentKey: Code[30];
    //     L_RProdOrderComponent: Record "Prod. Order Component";
    //     L_TotProdOrderFeasibleQty, L_TotComponentFeasibleQty, L_ExternalFeasibleQty, L_InternalFeasibleQty : Decimal;
    // begin
    //     L_TotProdOrderFeasibleQty := P_ProdOrderRemainingQty;
    //     L_RProdOrderComponent.Copy(V_RProdOrderComponent);
    //     if L_RProdOrderComponent.FindSet() then
    //         repeat
    //             L_TotComponentFeasibleQty := 0;
    //             L_ExternalFeasibleQty := 0;
    //             L_InternalFeasibleQty := 0;
    //             L_InternalInventoryAlreadyUsed := 0;
    //             L_ExternalInventoryAlreadyUsed := 0;
    //             L_ComponentKey := F_GetComponentKey(L_RProdOrderComponent."Item No.", L_RProdOrderComponent."Variant Code");
    //             if P_VendorNo <> '' then begin
    //                 if F_GetExternalQtyAlreadyUsedForComponent(L_ExternalInventoryAlreadyUsed, P_VendorNo, L_ComponentKey) then
    //                     L_ExternalInventoryAlreadyUsed := F_ConvertComponentQtyToProdOrderFinishedQty(L_ExternalInventoryAlreadyUsed, L_RProdOrderComponent."Quantity per", L_RProdOrderComponent."Qty. per Unit of Measure");
    //                 if (P_RTempSubcFeasibility1."External Inventory" - L_ExternalInventoryAlreadyUsed) >= L_RProdOrderComponent."Remaining Qty. (Base)" then
    //                     L_ExternalFeasibleQty := L_RProdOrderComponent."Remaining Qty. (Base)"
    //                 else
    //                     L_ExternalFeasibleQty := (P_RTempSubcFeasibility1."External Inventory" - L_ExternalInventoryAlreadyUsed);
    //             end;
    //             if F_GetInternalQtyAlreadyUsedForComponent(L_InternalInventoryAlreadyUsed, P_RTempSubcFeasibility1."Internal Location", L_ComponentKey) then
    //                 L_InternalInventoryAlreadyUsed := F_ConvertComponentQtyToProdOrderFinishedQty(L_InternalInventoryAlreadyUsed, L_RProdOrderComponent."Quantity per", L_RProdOrderComponent."Qty. per Unit of Measure");
    //             if L_ExternalFeasibleQty < L_RProdOrderComponent."Remaining Qty. (Base)" then begin
    //                 if (P_RTempSubcFeasibility1."Internal Inventory" - L_InternalInventoryAlreadyUsed) >= (L_RProdOrderComponent."Remaining Qty. (Base)" - L_ExternalFeasibleQty) then
    //                     L_InternalFeasibleQty := (L_RProdOrderComponent."Remaining Qty. (Base)" - L_ExternalFeasibleQty)
    //                 else
    //                     L_InternalFeasibleQty := (P_RTempSubcFeasibility1."Internal Inventory" - L_InternalInventoryAlreadyUsed);
    //             end;
    //             L_TotComponentFeasibleQty := L_ExternalFeasibleQty + L_InternalFeasibleQty;
    //             L_TotComponentFeasibleQty := F_ConvertComponentQtyToProdOrderFinishedQty(L_TotComponentFeasibleQty,
    //                                                                                      L_RProdOrderComponent."Quantity per",
    //                                                                                      L_RProdOrderComponent."Qty. per Unit of Measure");
    //             if (L_TotComponentFeasibleQty < L_TotProdOrderFeasibleQty) then
    //                 L_TotProdOrderFeasibleQty := L_TotComponentFeasibleQty;
    //         until L_RProdOrderComponent.Next() = 0;

    //     //TODO Fare che invece di calcolare qui dentro la qtà già convertita qui calcoli solo la qtà fattibile per l'ordine di produzione e ti calcoli fuori i componenti
    //     //TODO In modo che così puoi fare un dizionario per immagazzinare la qtà fattibile per ordine di produzione in modo da non doverla calcolare per tutti i componennti ma solo per il primo
    //     //TODO vedere se funziona
    //     // exit(F_ConvertProdOrderFinishedQtyToComponentQty(L_FeasibleQty, L_QtyPer, L_QtyPerUnitOfMeasure));
    //     exit(L_TotProdOrderFeasibleQty);
    // end;

    //TODO rivedere nome
    local procedure F_AddEntryInProdOrderDictionaryPerProdOrder(var V_ProdOrderNoForDrillDownQtyUsedByOtherPerProdOrder: Dictionary of [Text, Dictionary of [Code[30], Dictionary of [Code[10], Text]]]; P_RTempSubcFeasibility1: Record "TMP Subc. Feasibility 1 PTE"; P_ProdOrderNoList: Text; P_LocationCode: Code[10])
    begin
        F_AddEntryInProdOrderDictionaryPerProdOrder(V_ProdOrderNoForDrillDownQtyUsedByOtherPerProdOrder, P_RTempSubcFeasibility1."Prod. Order No.", P_RTempSubcFeasibility1."Prod. Order Line No.", P_RTempSubcFeasibility1."Item No.", P_RTempSubcFeasibility1."Variant Code", P_ProdOrderNoList, P_LocationCode);
    end;

    //TODO rivedere nome
    local procedure F_AddEntryInProdOrderDictionaryPerProdOrder(var V_ProdOrderNoForDrillDownQtyUsedByOtherPerProdOrder: Dictionary of [Text, Dictionary of [Code[30], Dictionary of [Code[10], Text]]]; P_ParentProdOrderNo: Code[20]; P_ParentProdOrderLineNo: Integer; P_ItemNo: Code[20]; P_VariantCode: Code[10]; P_ProdOrderNoList: Text; P_LocationCode: Code[10])
    var
        L_ProdOrderNoForDrillDownIntQtyUsedByOther: Dictionary of [Code[30], Dictionary of [Code[10], Text]];
        L_ProdOrderNoForDrillDownIntQtyUsedByOtherByLocation: Dictionary of [Code[10], Text];
        L_DummyProdOrderNoList: Text; //Usata solo per fare la GET
        L_ProdOrderKey: Text;
        L_ComponentDictionaryKey: Code[30];
    begin
        L_ProdOrderKey := P_ParentProdOrderNo + Format(P_ParentProdOrderLineNo);
        L_ComponentDictionaryKey := F_GetComponentKey(P_ItemNo, P_VariantCode);

        //TODO Vedere se questa funzione serve: funzione che serve per riempire il dizionario ProdOrderNoForDrillDownIntQtyUsedByOtherPerProdOrder
        if V_ProdOrderNoForDrillDownQtyUsedByOtherPerProdOrder.Get(L_ProdOrderKey, L_ProdOrderNoForDrillDownIntQtyUsedByOther) then begin
            if L_ProdOrderNoForDrillDownIntQtyUsedByOther.Get(L_ComponentDictionaryKey, L_ProdOrderNoForDrillDownIntQtyUsedByOtherByLocation) then begin
                if L_ProdOrderNoForDrillDownIntQtyUsedByOtherByLocation.Get(P_LocationCode, L_DummyProdOrderNoList) then begin
                    L_ProdOrderNoForDrillDownIntQtyUsedByOtherByLocation.Set(P_LocationCode, P_ProdOrderNoList);
                end else begin
                    L_ProdOrderNoForDrillDownIntQtyUsedByOtherByLocation.Add(P_LocationCode, P_ProdOrderNoList);
                end;
                L_ProdOrderNoForDrillDownIntQtyUsedByOther.Set(L_ComponentDictionaryKey, L_ProdOrderNoForDrillDownIntQtyUsedByOtherByLocation);
            end else begin
                L_ProdOrderNoForDrillDownIntQtyUsedByOtherByLocation.Add(P_LocationCode, P_ProdOrderNoList);
                L_ProdOrderNoForDrillDownIntQtyUsedByOther.Add(L_ComponentDictionaryKey, L_ProdOrderNoForDrillDownIntQtyUsedByOtherByLocation);
            end;
            V_ProdOrderNoForDrillDownQtyUsedByOtherPerProdOrder.Set(L_ProdOrderKey, L_ProdOrderNoForDrillDownIntQtyUsedByOther);
        end else begin
            L_ProdOrderNoForDrillDownIntQtyUsedByOtherByLocation.Add(P_LocationCode, P_ProdOrderNoList);
            L_ProdOrderNoForDrillDownIntQtyUsedByOther.Add(L_ComponentDictionaryKey, L_ProdOrderNoForDrillDownIntQtyUsedByOtherByLocation);
            V_ProdOrderNoForDrillDownQtyUsedByOtherPerProdOrder.Add(L_ProdOrderKey, L_ProdOrderNoForDrillDownIntQtyUsedByOther);
        end;
    end;

    //TODO rivedere nome
    local procedure F_AddEntryInProdOrderDictionary(var V_ProdOrderNoForDrillDownIntQtyUsedByOther: Dictionary of [Code[30], Dictionary of [Code[10], Text]]; P_RTempSubcFeasibility1: Record "TMP Subc. Feasibility 1 PTE"; P_LocationCode: Code[10])
    begin
        F_AddEntryInProdOrderDictionary(V_ProdOrderNoForDrillDownIntQtyUsedByOther, P_RTempSubcFeasibility1."Item No.", P_RTempSubcFeasibility1."Variant Code", P_RTempSubcFeasibility1."Prod. Order No.", P_LocationCode);
    end;

    //TODO rivedere nome
    local procedure F_AddEntryInProdOrderDictionary(var V_ProdOrderNoForDrillDownIntQtyUsedByOther: Dictionary of [Code[30], Dictionary of [Code[10], Text]]; P_ItemNo: Code[20]; P_VariantCode: Code[10]; P_ProdOrderNo: Code[20]; P_LocationCode: Code[10])
    var
        L_ListOfProdOrderNo: Text;
        L_ProdOrderNo: Code[20];
        L_ComponentDictionaryKey: Code[30];
        L_LocationCodeDictionary: Dictionary of [Code[10], Text];
    begin
        L_ComponentDictionaryKey := F_GetComponentKey(P_ItemNo, P_VariantCode);

        if V_ProdOrderNoForDrillDownIntQtyUsedByOther.Get(L_ComponentDictionaryKey, L_LocationCodeDictionary) then begin
            if L_LocationCodeDictionary.Get(P_LocationCode, L_ListOfProdOrderNo) then begin
                if L_ListOfProdOrderNo = '' then
                    L_ListOfProdOrderNo := P_ProdOrderNo
                else
                    L_ListOfProdOrderNo += '|' + P_ProdOrderNo;
                L_LocationCodeDictionary.Set(P_LocationCode, L_ListOfProdOrderNo);
            end else begin
                if L_ListOfProdOrderNo = '' then
                    L_ListOfProdOrderNo := P_ProdOrderNo
                else
                    L_ListOfProdOrderNo += '|' + P_ProdOrderNo;
                L_LocationCodeDictionary.Add(P_LocationCode, L_ListOfProdOrderNo);
            end;
            V_ProdOrderNoForDrillDownIntQtyUsedByOther.Set(L_ComponentDictionaryKey, L_LocationCodeDictionary);
        end else begin
            L_LocationCodeDictionary.Add(P_LocationCode, P_ProdOrderNo);
            V_ProdOrderNoForDrillDownIntQtyUsedByOther.Add(L_ComponentDictionaryKey, L_LocationCodeDictionary);
        end;
    end;

    //TODO rivedere nome
    local procedure F_GetEntryFromProdOrderDictionary(var V_ListOfProdOrder: Text; P_ProdOrderNoForDrillDownIntQtyUsedByOther: Dictionary of [Code[30], Dictionary of [Code[10], Text]]; P_RTempSubcFeasibility1: Record "TMP Subc. Feasibility 1 PTE"; P_LocationCode: Code[10]): Boolean
    begin
        exit(F_GetEntryFromProdOrderDictionary(V_ListOfProdOrder, P_ProdOrderNoForDrillDownIntQtyUsedByOther, P_RTempSubcFeasibility1."Item No.", P_RTempSubcFeasibility1."Variant Code", P_LocationCode));
    end;

    //TODO rivedere nome
    local procedure F_GetEntryFromProdOrderDictionary(var V_ListOfProdOrder: Text; P_ProdOrderNoForDrillDownIntQtyUsedByOther: Dictionary of [Code[30], Dictionary of [Code[10], Text]]; P_ItemNo: Code[20]; P_VariantCode: Code[10]; P_LocationCode: Code[10]): Boolean
    var
        L_LocationCodeDictionary: Dictionary of [Code[10], Text];
        L_ComponentDictionaryKey: Code[30];
    begin
        Clear(V_ListOfProdOrder);
        L_ComponentDictionaryKey := F_GetComponentKey(P_ItemNo, P_VariantCode);

        if not P_ProdOrderNoForDrillDownIntQtyUsedByOther.Get(L_ComponentDictionaryKey, L_LocationCodeDictionary) then
            exit(false);
        if not L_LocationCodeDictionary.Get(P_LocationCode, V_ListOfProdOrder) then
            exit(false);
        exit(true);
    end;

    //TODO funzione inutile e non utilizzata, intanto commentata ma poi sarà da rimuovere
    // local procedure F_SetQtyOnSubcFeas1(var V_RTempSubcFeasibility1: Record "TMP Subc. Feasibility 1 PTE")
    // var
    //     L_RTempSubcFeas1: Record "TMP Subc. Feasibility 1 PTE" temporary;
    //     L_ExternalInventoryAlreadyUsed: Decimal;
    //     L_ExternalInventoryCanBeUsed: Decimal;
    //     L_InternalInventoryAlreadyUsed: Decimal;
    //     L_InternalInventoryCanBeUsed: Decimal;
    // begin
    //     L_RTempSubcFeas1.Copy(V_RTempSubcFeasibility1, true);
    //     L_RTempSubcFeas1.Reset();
    //     if L_RTempSubcFeas1.FindSet(true) then
    //         repeat
    //             if F_GetEntryFromDictionary(InternalInventoryCanBeUsedDictionary, L_RTempSubcFeas1."Prod. Order No.", L_RTempSubcFeas1."Item No.", L_RTempSubcFeas1."Variant Code", L_InternalInventoryCanBeUsed) then
    //                 L_RTempSubcFeas1."Int. Reserved Quantity (Base)" := L_InternalInventoryCanBeUsed;
    //             if F_GetEntryFromDictionary(InternalInventoryAlreadyUsedDictionary, L_RTempSubcFeas1."Prod. Order No.", L_RTempSubcFeas1."Item No.", L_RTempSubcFeas1."Variant Code", L_InternalInventoryAlreadyUsed) then
    //                 L_RTempSubcFeas1."Int. Qty. used Other (Base)" := L_InternalInventoryAlreadyUsed;
    //             if F_GetEntryFromDictionary(ExternalInventoryCanBeUsedDictionary, L_RTempSubcFeas1."Prod. Order No.", L_RTempSubcFeas1."Item No.", L_RTempSubcFeas1."Variant Code", L_ExternalInventoryCanBeUsed) then
    //                 L_RTempSubcFeas1."Subc. Reserved Quantity (Base)" := L_ExternalInventoryCanBeUsed;
    //             if F_GetEntryFromDictionary(ExternalInventoryAlreadyUsedDictionary, L_RTempSubcFeas1."Prod. Order No.", L_RTempSubcFeas1."Item No.", L_RTempSubcFeas1."Variant Code", L_ExternalInventoryAlreadyUsed) then
    //                 L_RTempSubcFeas1."Subc. Qty. used Other (Base)" := L_ExternalInventoryAlreadyUsed;
    //             L_RTempSubcFeas1.Modify(false);
    //         until L_RTempSubcFeas1.Next() = 0;
    // end;

    local procedure F_GetVendorFromProdOrderRoutingLine(P_RProdOrderRoutingLine: Record "Prod. Order Routing Line"): Code[20]
    var
        L_VendorNo: Code[20];
    begin
        if not F_GetVendorFromProdOrderRoutingLine(P_RProdOrderRoutingLine, L_VendorNo) then
            exit('');
        exit(L_VendorNo);
    end;

    local procedure F_GetVendorFromProdOrderRoutingLine(P_RProdOrderRoutingLine: Record "Prod. Order Routing Line"; var V_VendorNo: Code[20]): Boolean
    var
        L_RVendor: Record Vendor;
    begin
        V_VendorNo := '';
        if not F_GetVendorFromProdOrderRoutingLine(P_RProdOrderRoutingLine, L_RVendor) then
            exit(false);
        V_VendorNo := L_RVendor."No.";
        exit(true);
    end;

    local procedure F_GetVendorFromProdOrderRoutingLine(P_RProdOrderRoutingLine: Record "Prod. Order Routing Line"; var V_RVendor: Record Vendor): Boolean
    var
        L_RWorkCenter: Record "Work Center";
    begin
        exit(F_GetVendorFromProdOrderRoutingLine(P_RProdOrderRoutingLine, L_RWorkCenter, V_RVendor));
    end;

    local procedure F_GetVendorFromProdOrderRoutingLine(P_RProdOrderRoutingLine: Record "Prod. Order Routing Line"; var V_RWorkCenter: Record "Work Center"; var V_RVendor: Record Vendor): Boolean
    var
    begin
        Clear(V_RVendor);
        Clear(V_RWorkCenter);
        if not V_RWorkCenter.Get(P_RProdOrderRoutingLine."Work Center No.") then
            exit(false);
        if not V_RVendor.Get(V_RWorkCenter."Subcontractor No.") then
            exit(false);
        exit(true);
    end;

    procedure GetSubcontractorLocationFromProdOrderRoutingLine(P_RProdOrderRoutingLine: Record "Prod. Order Routing Line"; var V_LocationCode: Code[10]): Boolean
    var
        L_RWorkCenter: Record "Work Center";
    begin
        exit(GetSubcontractorLocationFromProdOrderRoutingLine(P_RProdOrderRoutingLine, L_RWorkCenter, V_LocationCode));
    end;

    //TODO spostare in una codeunit
    procedure GetSubcontractorLocationFromProdOrderRoutingLine(P_RProdOrderRoutingLine: Record "Prod. Order Routing Line"; var V_RWorkCenter: Record "Work Center"; var V_LocationCode: Code[10]): Boolean
    var
        L_RVendor: Record Vendor;
    begin
        if not F_GetVendorFromProdOrderRoutingLine(P_RProdOrderRoutingLine, V_RWorkCenter, L_RVendor) then
            exit(false);
        V_LocationCode := L_RVendor."Subcontracting Location Code";
        exit(true);
    end;

    local procedure F_AddEntryInDictionary(var V_ProdOrderDictionary: Dictionary of [Code[20], Dictionary of [Code[30], Decimal]]; P_RTempSubcFeasibility1: Record "TMP Subc. Feasibility 1 PTE" temporary; P_Qty: Decimal)
    begin
        F_AddEntryInDictionary(V_ProdOrderDictionary, P_RTempSubcFeasibility1."Prod. Order No.", P_RTempSubcFeasibility1."Item No.", P_RTempSubcFeasibility1."Variant Code", P_Qty);
    end;

    local procedure F_AddEntryInDictionary(var V_ProdOrderDictionary: Dictionary of [Code[20], Dictionary of [Code[30], Decimal]]; P_ProdOrderNo: Code[20]; P_ItemNo: Code[20]; P_VariantCode: Code[10]; P_Qty: Decimal)
    var
        L_ProdOrderComponentDictionary: Dictionary of [Code[30], Decimal];
        L_Qty: Decimal;
        L_ProdOrderComponentKey: Code[30];
    begin
        //Uso il codice articolo concatenato con la variante come chiave del dizionario in modo che il calcolo delle qtà comprenda anche la variante
        L_ProdOrderComponentKey := F_GetComponentKey(P_ItemNo, P_VariantCode);

        if V_ProdOrderDictionary.ContainsKey(P_ProdOrderNo) then begin
            L_ProdOrderComponentDictionary := V_ProdOrderDictionary.Get(P_ProdOrderNo);
            if L_ProdOrderComponentDictionary.ContainsKey(L_ProdOrderComponentKey) then begin
                L_Qty := L_ProdOrderComponentDictionary.Get(L_ProdOrderComponentKey);
                P_Qty += L_Qty;
                L_ProdOrderComponentDictionary.Set(L_ProdOrderComponentKey, P_Qty);
            end else begin
                L_ProdOrderComponentDictionary.Add(L_ProdOrderComponentKey, P_Qty);
            end;
            V_ProdOrderDictionary.Set(P_ProdOrderNo, L_ProdOrderComponentDictionary);
        end else begin
            L_ProdOrderComponentDictionary.Add(L_ProdOrderComponentKey, P_Qty);
            V_ProdOrderDictionary.Add(P_ProdOrderNo, L_ProdOrderComponentDictionary);
        end;
    end;

    local procedure F_GetEntryFromDictionary(P_ProdOrderDictionary: Dictionary of [Code[20], Dictionary of [Code[30], Decimal]]; P_RTempSubcFeasibility1: Record "TMP Subc. Feasibility 1 PTE" temporary; var V_Qty: Decimal): Boolean
    begin
        exit(F_GetEntryFromDictionary(P_ProdOrderDictionary, P_RTempSubcFeasibility1."Prod. Order No.", P_RTempSubcFeasibility1."Item No.", P_RTempSubcFeasibility1."Variant Code", V_Qty));
    end;

    local procedure F_GetEntryFromDictionary(P_ProdOrderDictionary: Dictionary of [Code[20], Dictionary of [Code[30], Decimal]]; P_ProdOrderNo: Code[20]; P_ItemNo: Code[20]; P_VariantCode: Code[10]; var V_Qty: Decimal): Boolean
    var
        L_ProdOrderComponentDictionary: Dictionary of [Code[30], Decimal];
        L_ProdOrderComponentKey: Code[30];
    begin
        V_Qty := 0;
        L_ProdOrderComponentKey := F_GetComponentKey(P_ItemNo, P_VariantCode);

        if not P_ProdOrderDictionary.Get(P_ProdOrderNo, L_ProdOrderComponentDictionary) then
            exit(false);
        if not L_ProdOrderComponentDictionary.Get(L_ProdOrderComponentKey, V_Qty) then
            exit(false);
        exit(true);
    end;

    local procedure F_GetComponentKey(P_ItemNo: Code[20]; P_VariantCode: Code[10]): Code[30]
    begin
        exit(P_ItemNo + P_VariantCode);
    end;

    //TODO Provare che funzioni
    local procedure F_CalcTotalInternalAndExternalComponentInventory(var V_RTMPSubcFeasibility: Record "TMP Subc. Feasibility PTE"; var V_RTMPSubcFeasibility1: Record "TMP Subc. Feasibility 1 PTE")
    var
        L_RItem: Record Item;
        L_RLocation: Record Location;
        L_RTransferLine: Record "Transfer Line";
        L_RProdOrderComponent: Record "Prod. Order Component";
        L_OtherLocationInventory, L_ComponentQtyInTransferOrder : Decimal;
        L_ComponentKey: Code[30];
        L_ComponentInventoryByInternalLocation, L_ComponentInventoryByInternalAndExternalLocation : Decimal;
    begin
        L_ComponentKey := F_GetComponentKey(V_RTMPSubcFeasibility1."Item No.", V_RTMPSubcFeasibility1."Variant Code");

        if not L_RItem.Get(V_RTMPSubcFeasibility1."Item No.") then
            Clear(L_RItem);
        L_RItem."Rounding Precision" := 0.001;

        //Quantità in transferimento da giacenza interna a giacenza del terzista
        L_RTransferLine.SetCurrentKey("Item No.", "Variant Code");
        L_RTransferLine.SetRange("Item No.", V_RTMPSubcFeasibility1."Item No.");
        L_RTransferLine.SetRange("Variant Code", V_RTMPSubcFeasibility1."Variant Code");
        L_RTransferLine.SetRange("Transfer-to Code", V_RTMPSubcFeasibility."Subcontracting Location Code");
        if not L_RTransferLine.IsEmpty then begin
            L_RTransferLine.CalcSums("Quantity (Base)", "Qty. Received (Base)", "Qty. in Transit (Base)");
            V_RTMPSubcFeasibility."Comp. Trans. Order Exists" := true;
            V_RTMPSubcFeasibility.Modify;
            V_RTMPSubcFeasibility1."Qty. in Transfer Order" := Round(L_RTransferLine."Quantity (Base)" + L_RTransferLine."Qty. in Transit (Base)" - L_RTransferLine."Qty. Received (Base)", L_RItem."Rounding Precision", '>');
            // //Calcolo il dizionario che contiene la qtà globale negli ordini di trasferimento per ogni componente
            // if V_RTMPSubcFeasibility1."Qty. in Transfer Order" > 0 then
            //     if QtyInTransferOrderPerLocationAndComponent.Get(L_ComponentKey, L_ComponentQtyInTransferOrder) then begin
            //         L_ComponentQtyInTransferOrder += V_RTMPSubcFeasibility1."Qty. in Transfer Order";
            //         QtyInTransferOrderPerLocationAndComponent.Set(L_ComponentKey, L_ComponentQtyInTransferOrder)
            //     end else begin
            //         L_ComponentQtyInTransferOrder := V_RTMPSubcFeasibility1."Qty. in Transfer Order";
            //         QtyInTransferOrderPerLocationAndComponent.Add(L_ComponentKey, L_ComponentQtyInTransferOrder);
            //     end;
        end;

        //Trovo la giacenza in ordine di transferimento del componente che successivamente andrò a togliere in quanto questa verrà trasferita in un'altra ubicazione.
        L_ComponentInventoryByInternalLocation := F_GetQtyInTransferOrder(V_RTMPSubcFeasibility1."Internal Location", V_RTMPSubcFeasibility1."Item No.", V_RTMPSubcFeasibility1."Variant Code");
        L_ComponentInventoryByInternalAndExternalLocation := F_GetQtyInTransferOrder(V_RTMPSubcFeasibility1."Internal Location", V_RTMPSubcFeasibility1."External Location", V_RTMPSubcFeasibility1."Item No.", V_RTMPSubcFeasibility1."Variant Code");

        L_RItem.SetRange("Variant Filter", V_RTMPSubcFeasibility1."Variant Code");
        //Gianceza interna
        L_RItem.SetRange("Location Filter", V_RTMPSubcFeasibility."Location Code");
        L_RItem.CalcFields(Inventory);
        V_RTMPSubcFeasibility1."Internal Inventory" := Round(L_RItem.Inventory - L_ComponentInventoryByInternalLocation, L_RItem."Rounding Precision", '<');
        if V_RTMPSubcFeasibility1."Internal Inventory" < 0 then
            V_RTMPSubcFeasibility1."Internal Inventory" := 0;

        //Giacenza interna altre ubicazioni
        L_RItem.SetFilter("Location Filter", InternalLocationFilter);
        L_RItem.FilterGroup(20);
        L_RItem.SetFilter("Location Filter", '<>%1', V_RTMPSubcFeasibility."Location Code");
        L_RItem.FilterGroup(0);
        L_RItem.CalcFields(Inventory);
        V_RTMPSubcFeasibility1."Internal Inventory Other Loc." := Round(L_RItem.Inventory, L_RItem."Rounding Precision", '<');
        L_RItem.FilterGroup(20);
        L_RItem.SetRange("Location Filter");
        L_RItem.FilterGroup(0);

        //Giacenza esterna dal terzista
        //TODO condizionare che è da calcolare solo se c'è una fase di conto lavoro
        //TODO l'ubicazione sarebbe da calcolare per ogni componente in base alla fase in cui sono prelevati perché così com'è ora si da per scontato che ci sia un solo terzista per ciclo, ma possono essere più di uno
        if V_RTMPSubcFeasibility.Subcontractor <> '' then begin
            L_RItem.SetRange("Location Filter", V_RTMPSubcFeasibility."Subcontracting Location Code");
            L_RItem.CalcFields(Inventory);
            V_RTMPSubcFeasibility1."External Inventory" := Round(L_RItem.Inventory + L_ComponentInventoryByInternalAndExternalLocation, L_RItem."Rounding Precision", '<');
        end;

        V_RTMPSubcFeasibility1."Global Inventory" := V_RTMPSubcFeasibility1."Internal Inventory" + V_RTMPSubcFeasibility1."External Inventory" + V_RTMPSubcFeasibility1."Qty. in Transfer Order";

        //Totale della quantità che il terzista deve ancora utilizzare per lo specifico componente
        //Esempio: 5 ordini che vanno al terzista PIPPO, per un totale di 100 pezzi da usare, di cui 60 già usati, 40 ancora da usare, ecco questa quantità riporterà 40
        L_RProdOrderComponent.SetCurrentKey("Item No.", "Variant Code", "Location Code", Status, "Due Date");
        L_RProdOrderComponent.SetRange("Item No.", V_RTMPSubcFeasibility1."Item No.");
        L_RProdOrderComponent.SetRange("Variant Code", V_RTMPSubcFeasibility1."Variant Code");
        L_RProdOrderComponent.SetRange("Location Code", V_RTMPSubcFeasibility."Subcontracting Location Code");
        L_RProdOrderComponent.SetRange(Status, L_RProdOrderComponent.Status::Released);
        L_RProdOrderComponent.CalcSums("Remaining Qty. (Base)"); //Quantità rimanente ancora da usare
        V_RTMPSubcFeasibility1."Total Subc. Rem. Qty. (Base)" := L_RProdOrderComponent."Remaining Qty. (Base)";

        //Totale della quantità interna del componente che deve ancora essere utilizzata
        L_RProdOrderComponent.SetRange("Location Code", V_RTMPSubcFeasibility."Location Code");
        L_RProdOrderComponent.CalcSums("Remaining Qty. (Base)");
        V_RTMPSubcFeasibility1."Qty. on Int. Component Lines" := L_RProdOrderComponent."Remaining Qty. (Base)";
    end;

    //DUPLICATED c'è anche in page "FLEXSubcontactorFeasibility1PTE"
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

    procedure F_SetCurrentKeyOnRec()
    begin
        Rec.SetCurrentKey("Status Order", "Due Date", "Prod. Order No.", "Line No.");
    end;

    local procedure F_FilterProdOrdersForComponentUsingInventory(P_ProdOrderNoForDrillDownQtyUsedByOtherPerProdOrder: Dictionary of [Text, Dictionary of [Code[30], Dictionary of [Code[10], Text]]]; P_LocationType: Option Int,Ext): Boolean
    var
        L_ProdOrderFilter: Text;
        L_ItemNo: Code[20];
        L_VariantCode, L_InternalLocation, L_ExternalLocation, L_LocationCode : Code[10];
    begin
        CurrPage.ComponentsPart.Page.GetRecComponent(L_ItemNo, L_VariantCode);
        CurrPage.ComponentsPart.Page.GetRecLocation(L_InternalLocation, L_ExternalLocation);

        case P_LocationType of
            P_LocationType::Int:
                L_LocationCode := L_InternalLocation;
            P_LocationType::Ext:
                L_LocationCode := L_ExternalLocation;
        end;

        F_GetProdOrderFilterFromDictionaryForQty(P_ProdOrderNoForDrillDownQtyUsedByOtherPerProdOrder,
                                                 L_ProdOrderFilter,
                                                 Rec."Prod. Order No.",
                                                 Rec."Line No.",
                                                 L_ItemNo,
                                                 L_VariantCode,
                                                 L_LocationCode);
        if L_ProdOrderFilter = '' then
            exit(false);
        L_ProdOrderFilter += '|' + Rec."Prod. Order No.";
        Rec.Reset();
        F_SetCurrentKeyOnRec();
        Rec.FilterGroup(20);
        Rec.SetFilter("Prod. Order No.", L_ProdOrderFilter);
        Rec.FilterGroup(0);
        CurrPage.ComponentsPart.Page.SetFilterOnComponent(L_ItemNo, L_VariantCode);
        exit(true);
    end;

    local procedure F_HaveProdOrderComponentWithAvailableInventory(P_ProdOrderStatus: Enum "Production Order Status"; P_ProdOrderNo: Code[20];
                                                                                          P_ProdOrderLineNo: Integer): Boolean
    var
        L_RTempSubcFeasibility1: Record "TMP Subc. Feasibility 1 PTE" temporary;
    begin
        L_RTempSubcFeasibility1.Copy(TempRSubcFeas1, true);
        L_RTempSubcFeasibility1.Reset();
        L_RTempSubcFeasibility1.SetRange(Status, P_ProdOrderStatus);
        L_RTempSubcFeasibility1.SetRange("Prod. Order No.", P_ProdOrderNo);
        L_RTempSubcFeasibility1.SetRange("Prod. Order Line No.", P_ProdOrderLineNo);
        L_RTempSubcFeasibility1.SetFilter("Remaining Qty. (Base)", '>%1', 0);
        L_RTempSubcFeasibility1.FilterGroup(-1);
        L_RTempSubcFeasibility1.SetFilter("Int. Reserved Quantity (Base)", '>%1', 0);
        L_RTempSubcFeasibility1.SetFilter("Subc. Reserved Quantity (Base)", '>%1', 0);
        L_RTempSubcFeasibility1.FilterGroup(0);
        exit(not L_RTempSubcFeasibility1.IsEmpty);
    end;

    local procedure F_CreateTransferOrder(var V_RTempSubcFeasibility1: Record "TMP Subc. Feasibility 1 PTE" temporary)
    var
        L_InternalLocationList: List of [Code[10]];
        L_ExternalLocationList: List of [Code[10]];
        L_RTransferHeader: Record "Transfer Header";
        L_LineNo: Integer;
        L_RTransferLine: Record "Transfer Line";
        L_RLocation: Record Location;
        L_InTransitLocationCode: Code[10];
        L_RTempSubcFeasibility1: Record "TMP Subc. Feasibility 1 PTE" temporary;
        L_ExternalInventoryCanBeUsed, L_InternalInventoryCanBeUsed : Decimal;
        L_TransferOrderCreationConfirm: Label 'Do you confirm transfer order creation?';
        L_PartialTransferOrderLineInsertConfirm: Label 'For one or more selected components, available internal inventory is insufficient to fully cover the remaining quantity. Do you still want to create the transfer order?';
        L_NoComponentForTransferOrderErr: Label 'No suitable components are available in production order %1 to create a transfer order.';
    begin
        if V_RTempSubcFeasibility1.IsEmpty then
            Error(L_NoComponentForTransferOrderErr, Rec."Prod. Order No.");

        F_DoCheckForTransferLine(V_RTempSubcFeasibility1);

        if not Confirm(L_TransferOrderCreationConfirm, false) then
            exit;

        //Chiedo conferma se si vuole continuare con la creazione dell'ordine di transferimento anche se ci sono componenti con giacenza interna che copre solo parzialmente il fabbisogno 
        L_RTempSubcFeasibility1.Copy(V_RTempSubcFeasibility1, true);
        if L_RTempSubcFeasibility1.FindSet() then
            repeat
                if (L_RTempSubcFeasibility1."Int. Reserved Quantity (Base)" + L_RTempSubcFeasibility1."Subc. Qty. used Other (Base)") < L_RTempSubcFeasibility1."Remaining Qty. (Base)" then begin
                    if not Confirm(L_PartialTransferOrderLineInsertConfirm, false, L_RTempSubcFeasibility1."Item No." + ' ' + L_RTempSubcFeasibility1."Component Description") then
                        exit;
                    break;
                end;
            until L_RTempSubcFeasibility1.Next() = 0;

        //Se c'è più di un ubicazione da usare come transito la faccio scegliere
        L_RLocation.SetRange("Use As In-Transit", true);
        if L_RLocation.Count = 1 then begin
            if L_RLocation.FindFirst() then
                L_InTransitLocationCode := L_RLocation.Code;
        end else begin
            if Page.RunModal(0, L_RLocation) <> Action::LookupOK then
                exit;
            L_InTransitLocationCode := L_RLocation.Code;
        end;

        L_RTempSubcFeasibility1.Copy(V_RTempSubcFeasibility1, true);
        if L_RTempSubcFeasibility1.FindSet() then begin
            repeat
                if (not L_InternalLocationList.Contains(L_RTempSubcFeasibility1."Internal Location")) or
                   (not L_ExternalLocationList.Contains(L_RTempSubcFeasibility1."External Location")) then begin
                    L_InternalLocationList.Add(L_RTempSubcFeasibility1."Internal Location");
                    L_ExternalLocationList.Add(L_RTempSubcFeasibility1."External Location");
                    L_RTransferHeader.Init();
                    L_RTransferHeader."No." := '';
                    L_RTransferHeader.Insert(true);
                    L_RTransferHeader.Validate("Transfer-from Code", L_RTempSubcFeasibility1."Internal Location");
                    L_RTransferHeader.Validate("Transfer-to Code", L_RTempSubcFeasibility1."External Location");
                    L_RTransferHeader.Validate("In-Transit Code", L_InTransitLocationCode);
                    L_RTransferHeader.Modify(true);
                    L_LineNo := 0;
                end;
                L_LineNo += 10000;
                L_RTransferLine.Init;
                L_RTransferLine."Document No." := L_RTransferHeader."No.";
                L_RTransferLine."Line No." := L_LineNo;
                L_RTransferLine.Validate("Item No.", L_RTempSubcFeasibility1."Item No.");
                L_RTransferLine.Validate("Variant Code", L_RTempSubcFeasibility1."Variant Code");
                L_RTransferLine.Validate("Quantity (Base)", L_RTempSubcFeasibility1."Int. Reserved Quantity (Base)");
                L_RTransferLine.Validate("Qty. to Ship (Base)", L_RTempSubcFeasibility1."Int. Reserved Quantity (Base)");
                L_RTransferLine.Insert(true);
            until L_RTempSubcFeasibility1.Next() = 0;
        end;

        Page.Run(Page::"Transfer Order", L_RTransferHeader);
    end;

    local procedure F_DoCheckForTransferLine(var V_RTempSubcFeasibility1: Record "TMP Subc. Feasibility 1 PTE" temporary)
    var
        L_RTempSubcFeasibility1: Record "TMP Subc. Feasibility 1 PTE" temporary;
        L_RTempErrorMessage: Record "Error Message" temporary;
        L_NoSubcontractorErr: Label 'Component %1 must not be processed by a subcontractor. Unable to proceed with transfer order creation.';
        L_NoTransferRequiredErr: Label 'No transfer is required for component %1, as the external inventory covers the required quantity.';
        L_NoInternalInventoryErr: Label 'No internal inventory is available for component %1. It is not possible to create the transfer order.';
        L_NoInTransitLocation: Label 'There are no locations to use for the transit. The transfer order cannot be created.';
        L_RLocation: Record Location;
    begin
        L_RLocation.SetRange("Use As In-Transit", true);
        if not L_RLocation.FindFirst() then
            L_RTempErrorMessage.LogSimpleMessage(L_RTempErrorMessage."Message Type"::Error, L_NoInTransitLocation)
        else begin
            L_RTempSubcFeasibility1.Copy(V_RTempSubcFeasibility1, true);
            if L_RTempSubcFeasibility1.FindSet() then
                repeat
                    if L_RTempSubcFeasibility1."External Location" <> '' then begin
                        if L_RTempSubcFeasibility1."Subc. Reserved Quantity (Base)" < L_RTempSubcFeasibility1."Remaining Qty. (Base)" then begin
                            if L_RTempSubcFeasibility1."Int. Reserved Quantity (Base)" = 0 then
                                L_RTempErrorMessage.LogSimpleMessage(L_RTempErrorMessage."Message Type"::Error, StrSubstNo(L_NoInternalInventoryErr, L_RTempSubcFeasibility1."Item No." + ' - ' + L_RTempSubcFeasibility1."Component Description"));
                        end else
                            L_RTempErrorMessage.LogSimpleMessage(L_RTempErrorMessage."Message Type"::Error, StrSubstNo(L_NoTransferRequiredErr, L_RTempSubcFeasibility1."Item No." + ' - ' + L_RTempSubcFeasibility1."Component Description"));
                    end else
                        L_RTempErrorMessage.LogSimpleMessage(L_RTempErrorMessage."Message Type"::Error, StrSubstNo(L_NoSubcontractorErr, L_RTempSubcFeasibility1."Item No." + ' - ' + L_RTempSubcFeasibility1."Component Description"));
                until L_RTempSubcFeasibility1.Next() = 0;
        end;

        L_RTempErrorMessage.ShowErrorMessages(true);
    end;

    /// <summary>
    /// Recupera la quantità totale del componente presente nelle righe degli ordini di trasferimento, filtrando per ubicazione di partenza e ubicazione di destinazione.
    /// </summary>    
    local procedure F_GetQtyInTransferOrder(P_FromLocationCode: Code[10]; P_ToLocationCode: Code[10]; P_ItemNo: Code[20]; P_VariantCode: Code[10]): Decimal
    var
        L_QtyInTransferOrder: Decimal;
        L_ComponentKey: Code[30];
        L_QtyInTransferOrderPerComponent: Dictionary of [Code[30], Decimal];
        L_QtyInTransferOrderPerExternalLocationAndComponent: Dictionary of [Code[10], Dictionary of [Code[30], Decimal]];
    begin
        L_ComponentKey := F_GetComponentKey(P_ItemNo, P_VariantCode);
        if TransferredQtyPerComponent.Get(P_FromLocationCode, L_QtyInTransferOrderPerExternalLocationAndComponent) then begin
            if L_QtyInTransferOrderPerExternalLocationAndComponent.Get(P_ToLocationCode, L_QtyInTransferOrderPerComponent) then begin
                if L_QtyInTransferOrderPerComponent.Get(L_ComponentKey, L_QtyInTransferOrder) then
                    exit(L_QtyInTransferOrder);
                L_QtyInTransferOrder := F_CalcQtyInTransferOrderPerLocationAndComponent(P_FromLocationCode, P_ToLocationCode, P_ItemNo, P_VariantCode);
                if L_QtyInTransferOrder = 0 then
                    exit(0);
                L_QtyInTransferOrderPerComponent.Add(L_ComponentKey, L_QtyInTransferOrder);
                L_QtyInTransferOrderPerExternalLocationAndComponent.Set(P_ToLocationCode, L_QtyInTransferOrderPerComponent);
            end else begin
                L_QtyInTransferOrder := F_CalcQtyInTransferOrderPerLocationAndComponent(P_FromLocationCode, P_ToLocationCode, P_ItemNo, P_VariantCode);
                if L_QtyInTransferOrder = 0 then
                    exit(0);
                L_QtyInTransferOrderPerComponent.Add(L_ComponentKey, L_QtyInTransferOrder);
                L_QtyInTransferOrderPerExternalLocationAndComponent.Add(P_ToLocationCode, L_QtyInTransferOrderPerComponent);
            end;
            TransferredQtyPerComponent.Set(P_FromLocationCode, L_QtyInTransferOrderPerExternalLocationAndComponent);
        end else begin
            L_QtyInTransferOrder := F_CalcQtyInTransferOrderPerLocationAndComponent(P_FromLocationCode, P_ToLocationCode, P_ItemNo, P_VariantCode);
            if L_QtyInTransferOrder = 0 then
                exit(0);
            L_QtyInTransferOrderPerComponent.Add(L_ComponentKey, L_QtyInTransferOrder);
            L_QtyInTransferOrderPerExternalLocationAndComponent.Add(P_ToLocationCode, L_QtyInTransferOrderPerComponent);
            TransferredQtyPerComponent.Add(P_FromLocationCode, L_QtyInTransferOrderPerExternalLocationAndComponent);
        end;
        exit(L_QtyInTransferOrder);
    end;

    /// <summary>
    /// Recupera la quantità totale del componente presente nelle righe degli ordini di trasferimento, filtrando per ubicazione di partenza.
    /// </summary>    
    local procedure F_GetQtyInTransferOrder(P_FromLocationCode: Code[10]; P_ItemNo: Code[20]; P_VariantCode: Code[10]): Decimal
    var
        L_QtyInTransferOrder: Decimal;
        L_ComponentKey: Code[30];
        L_QtyInTransferOrderPerComponent: Dictionary of [Code[30], Decimal];
    begin
        L_ComponentKey := F_GetComponentKey(P_ItemNo, P_VariantCode);
        if GlobalQtyInTransferOrderPerInternalLocationAndComponent.Get(P_FromLocationCode, L_QtyInTransferOrderPerComponent) then begin
            if L_QtyInTransferOrderPerComponent.Get(L_ComponentKey, L_QtyInTransferOrder) then
                exit(L_QtyInTransferOrder);
            L_QtyInTransferOrder := F_CalcQtyInTransferOrderPerLocationAndComponent(P_FromLocationCode, P_ItemNo, P_VariantCode);
            if L_QtyInTransferOrder = 0 then
                exit(0);
            L_QtyInTransferOrderPerComponent.Add(L_ComponentKey, L_QtyInTransferOrder);
            GlobalQtyInTransferOrderPerInternalLocationAndComponent.Set(P_FromLocationCode, L_QtyInTransferOrderPerComponent);
        end else begin
            L_QtyInTransferOrder := F_CalcQtyInTransferOrderPerLocationAndComponent(P_FromLocationCode, P_ItemNo, P_VariantCode);
            if L_QtyInTransferOrder = 0 then
                exit(0);
            L_QtyInTransferOrderPerComponent.Add(L_ComponentKey, L_QtyInTransferOrder);
            GlobalQtyInTransferOrderPerInternalLocationAndComponent.Add(P_FromLocationCode, L_QtyInTransferOrderPerComponent);
        end;
        exit(L_QtyInTransferOrder);
    end;

    local procedure F_CalcQtyInTransferOrderPerLocationAndComponent(P_FromLocationCode: Code[10]; P_ItemNo: Code[20]; P_VariantCode: Code[10]): Decimal
    begin
        exit(F_CalcQtyInTransferOrderPerLocationAndComponent(P_FromLocationCode, '', P_ItemNo, P_VariantCode));
    end;

    local procedure F_CalcQtyInTransferOrderPerLocationAndComponent(P_FromLocationCode: Code[10]; P_ToLocationCode: Code[10]; P_ItemNo: Code[20]; P_VariantCode: Code[10]): Decimal
    var
        L_RTransferLine: Record "Transfer Line";
    begin
        L_RTransferLine.SetRange("Transfer-from Code", P_FromLocationCode);
        if P_ToLocationCode <> '' then
            L_RTransferLine.SetRange("Transfer-to Code", P_ToLocationCode);
        L_RTransferLine.SetRange("Item No.", P_ItemNo);
        L_RTransferLine.SetRange("Variant Code", P_VariantCode);
        if L_RTransferLine.IsEmpty then
            exit(0);
        L_RTransferLine.CalcSums("Quantity (Base)", "Qty. in Transit (Base)", "Qty. Received (Base)");
        exit(L_RTransferLine."Quantity (Base)" + L_RTransferLine."Qty. in Transit (Base)" - L_RTransferLine."Qty. Received (Base)");
    end;

    // local procedure F_ReloadPageToApplyOption() BReloaded: Boolean
    // var
    //     L_ReloadToApplyOptionConfirm: label 'The page must be reloaded to apply the selected option; you can do this later, but the option will not be active until the page is reloaded. Do you want to proceed?';
    // //!IN italiano: È necessario ricaricare la pagina per applicare l’opzione impostata; in alternativa puoi farlo più tardi, ma l’opzione non sarà attiva fino al ricaricamento. Confermi?
    // begin
    //     exit(F_ReloadPage(L_ReloadToApplyOptionConfirm));
    // end;

    // local procedure F_ReloadPageToApplyDueDateChange() BReloaded: Boolean
    // var
    //     L_ReloadToDueDateChangesConfirm: Label 'The page must be reloaded to recalculate the feasibility of production orders. Alternatively, you can do it later, but component inventory commitments may be incorrect and some features may be disabled. Do you want to continue?';
    // //! In italiano È necessario ricaricare la pagina per ricalcolare la fattibilità degli ordini di produzione. In alternativa puoi farlo più tardi, ma gli impegni sulle giacenze dei componenti potrebbero non essere corretti e alcune funzionalità potrebbero risultare disattivate. Vuoi continuare?
    // begin
    //     exit(F_ReloadPage(L_ReloadToDueDateChangesConfirm));
    // end;

    // local procedure F_ReloadPage(P_ConfirmTxt: Text) BReloaded: Boolean
    // var
    //     L_RTempRec: Record "TMP Subc. Feasibility PTE" temporary;
    // begin
    //     L_RTempRec.Copy(Rec, true);
    //     L_RTempRec.Reset();
    //     if L_RTempRec.IsEmpty then
    //         exit(false);
    //     if not CConfirmManagement.GetResponseOrDefault(P_ConfirmTxt, true) then
    //         exit(false);
    //     F_LoadData();
    // end;

    local procedure F_ReloadPageToApplyOption()
    var
        L_RTempRec: Record "TMP Subc. Feasibility PTE" temporary;
        L_ReloadToApplyOptionConfirm: label 'The page must be reloaded to apply the selected option; you can do this later, but the option will not be active until the page is reloaded. Do you want to proceed?';
    //!IN italiano: È necessario ricaricare la pagina per applicare l’opzione impostata; in alternativa puoi farlo più tardi, ma l’opzione non sarà attiva fino al ricaricamento. Confermi?
    begin
        L_RTempRec.Copy(Rec, true);
        L_RTempRec.Reset();
        if L_RTempRec.IsEmpty then
            exit;
        if not CConfirmManagement.GetResponseOrDefault(L_ReloadToApplyOptionConfirm, true) then
            exit;
        F_LoadData();
    end;

    //TODO Procedure che sarà da spostare in Flex_Manufacturing_Interface perché la pagina è nella starter
    local procedure F_ShowBinContent(P_ItemNo: Code[20]; P_VariantCode: Code[10]; P_LocationCode: Code[10])
    var
        L_RLocation: Record Location;
        L_RBinContentTracking: Record "Bin Content Tracking FLE";
    begin
        L_RLocation.Get(P_LocationCode);
        L_RLocation.TestField("Bin Mandatory", true);

        L_RBinContentTracking.SetRange("Item No.", P_ItemNo);
        L_RBinContentTracking.SetRange("Variant Code", P_VariantCode);
        L_RBinContentTracking.SetRange("Location Code", P_LocationCode);
        Page.Run(Page::"Bin Contents Tracking FLE", L_RBinContentTracking);
    end;

    [TryFunction]
    local procedure F_CheckThatProdOrderIsExternal(P_RTempTMPSubcFeasibility: Record "TMP Subc. Feasibility PTE" temporary)
    var
        L_NoExternalOperation: Label 'The production order does not have external operations that consume components.';
    begin
        F_CheckThatProdOrderIsExternal(P_RTempTMPSubcFeasibility, L_NoExternalOperation);
    end;

    [TryFunction]
    local procedure F_CheckThatProdOrderIsExternal(P_RTempTMPSubcFeasibility: Record "TMP Subc. Feasibility PTE" temporary; P_ErrorText: Text)
    begin
        if P_RTempTMPSubcFeasibility.Subcontractor = '' then
            Error(P_ErrorText);
    end;

    local procedure F_DisableActionAndDrillDownAtDueDateChange()
    begin
        BDisableActionAndDrillDownAtDueDateChange := true;
        CurrPage.ComponentsPart.Page.DisableDrillDownOnInventoryUsedByOther();
    end;

    // /// <summary>
    // /// Procedure che ricalcola la fattibilità per gli ordini di produzione interessati dal cambio di data di scadenza.
    // /// Gli ordini interessati sono quelli compresi tra la data di scadenza originale e quella nuova.
    // /// </summary>
    // local procedure F_RecalcProdOrderFeasibilityForDueDateChanges(P_OriginalDueDate: Date; P_NewDueDate: Date)
    // var
    //     L_FromDate, L_ToDate : Date;
    //     L_RProdOrderLine: Record "Prod. Order Line";
    //     L_RTempRec, L_RTempRec2 : Record "TMP Subc. Feasibility PTE" temporary;
    //     L_RTempRSubcFeas1, L_RTempRSubcFeas1_2 : Record "TMP Subc. Feasibility 1 PTE" temporary;
    //     L_ComponentKey: Code[30];
    //     L_InternalInventoryAlreadyUsed, L_ExternalInventoryAlreadyUsed : Decimal;
    //     L_InternalComponentInventoryAlreadyUsed, L_ExternalComponentInventoryAlreadyUsed : Dictionary of [Code[30], Decimal];
    //     L_RProdOrderRoutingLine: Record "Prod. Order Routing Line";
    //     L_VendorNo: Code[20];


    //     L_ProdOrderListDrillDown: List of [Text];
    //     L_ProdOrderDrillDown: Text;
    //     L_ProdOrderNoForDrillDownInternalQtyUsedByOther, L_ProdOrderNoForDrillDownExternalQtyUsedByOther : Dictionary of [Code[30], Dictionary of [Code[10], Text]]; // Copiati dalle variabili globali
    //     L_ProdOrder: Text;
    //     L_ProdOrderNoForDrillDownExtQtyUsedByOtherByLocation: Dictionary of [Code[10], Text];
    //     L_BMyOrder: Boolean;//TODO cambiare nome a questa variabile


    //     L_ProdOrderListBefore, L_ProdOrderListAfter : List of [Text];
    //     L_ProdOrderNoForDrillDownExternalBefore, L_ProdOrderNoForDrillDownExternalAfter : Dictionary of [Code[30], Dictionary of [Code[10], Text]];
    //     L_ProdOrderNoForDrillDownExternalByLocationBefore, L_ProdOrderNoForDrillDownExternalByLocationAfter : Dictionary of [Code[10], Text];
    //     L_ProdOrderString: Text;
    // begin
    //     case true of
    //         P_OriginalDueDate = P_NewDueDate:
    //             exit;
    //         P_OriginalDueDate < P_NewDueDate:
    //             begin
    //                 L_FromDate := P_OriginalDueDate;
    //                 L_ToDate := P_NewDueDate;
    //             end;
    //         P_NewDueDate < P_OriginalDueDate:
    //             begin
    //                 L_FromDate := P_NewDueDate;
    //                 L_ToDate := P_OriginalDueDate;
    //             end;
    //     end;

    //     L_RTempRec2.Copy(Rec, true);
    //     L_RTempRec2.Reset;
    //     L_RTempRSubcFeas1_2.Copy(TempRSubcFeas1, true);
    //     L_RTempRSubcFeas1_2.Reset;

    //     //Filtro gli ordini di produzione da ricalcolare
    //     F_CreateLocationFilter();
    //     F_FilterProdOrderLineToCalcFeasibility(L_RProdOrderLine, false, false);
    //     L_RProdOrderLine.SetRange("Due Date", L_FromDate, L_ToDate);

    //     //Elimino quali sono gli ordini di produzione che devo ricalcolare
    //     L_RTempRec2.SetRange("Due Date", L_FromDate, L_ToDate);
    //     if L_RTempRec2.FindSet() then
    //         repeat
    //             //Elimino la giacenza interna ed esterna impegnata dai componenti contenuta nei dizionari di totalizzazione
    //             L_RTempRSubcFeas1_2.FilterComponentByProdOrder(L_RTempRec2);
    //             if L_RTempRSubcFeas1_2.FindSet() then
    //                 repeat

    //                     //TODO capire anche se il ricalcolo parziale ha senso farlo (più veloce ma "pericoloso") oppure a sto punto fanculo ricalcolo tutto (più lento ma sicuro)

    //                     //TODO C'è qualcosa che non funziona capire cos'è, nel senso che il ricalcolo non calcola la qtà impegnata da altri in maniera corretta. Debuggare per capire perché. IN più fare poi anche dizionari Drilldown (TODO qui sotto)

    //                     //Rimuovo la giacenza interna impegnata da ogni compenente dell'ordine di produzione, in modo che al ricalcolo della fattibilità  non sia già impegnata.
    //                     L_ComponentKey := F_GetComponentKey(L_RTempRSubcFeas1_2."Item No.", L_RTempRSubcFeas1_2."Variant Code");
    //                     if L_RTempRSubcFeas1_2."Int. Reserved Quantity (Base)" > 0 then begin
    //                         if TotalInternalInventoryAlreadyUsed.Get(L_RTempRSubcFeas1_2."Internal Location", L_InternalComponentInventoryAlreadyUsed) then
    //                             if L_InternalComponentInventoryAlreadyUsed.Get(L_ComponentKey, L_InternalInventoryAlreadyUsed) then begin
    //                                 L_InternalComponentInventoryAlreadyUsed.Set(L_ComponentKey, L_InternalInventoryAlreadyUsed - L_RTempRSubcFeas1_2."Int. Reserved Quantity (Base)");
    //                                 TotalInternalInventoryAlreadyUsed.Set(L_RTempRSubcFeas1_2."Internal Location", L_InternalComponentInventoryAlreadyUsed);
    //                             end;
    //                     end;
    //                     //Rimuovo giacenza esterna impegnata da ogni compenente dell'ordine di produzione, in modo che al ricalcolo della fattibilità non sia già impegnata.
    //                     if L_RTempRSubcFeas1_2."Subc. Reserved Quantity (Base)" > 0 then begin
    //                         L_RProdOrderLine.get(L_RTempRec2.Status, L_RTempRec2."Prod. Order No.", L_RTempRec2."Line No.");
    //                         CGeneralManufacturing.FilterProdOrderRoutingLineFromProdOrderLine(L_RProdOrderRoutingLine, L_RProdOrderLine);
    //                         L_RProdOrderRoutingLine.SetRange("Routing Link Code", L_RTempRSubcFeas1_2."Routing Link Code");
    //                         if L_RProdOrderRoutingLine.FindFirst() then begin
    //                             L_VendorNo := F_GetVendorFromProdOrderRoutingLine(L_RProdOrderRoutingLine);
    //                             if TotalExternalInventoryAlreadyUsed.Get(L_VendorNo, L_ExternalComponentInventoryAlreadyUsed) then
    //                                 if L_ExternalComponentInventoryAlreadyUsed.Get(L_ComponentKey, L_ExternalInventoryAlreadyUsed) then begin
    //                                     L_ExternalComponentInventoryAlreadyUsed.Set(L_ComponentKey, L_ExternalInventoryAlreadyUsed - L_RTempRSubcFeas1_2."Subc. Reserved Quantity (Base)");
    //                                     TotalExternalInventoryAlreadyUsed.Set(L_VendorNo, L_ExternalComponentInventoryAlreadyUsed);
    //                                 end;
    //                         end;
    //                     end;
    //                 until L_RTempRSubcFeas1_2.next = 0;
    //             //Elimino i componenti dell'ordine di produzione
    //             CurrPage.ComponentsPart.Page.DeleteComponentForProdOrder(L_RTempRec2);
    //             L_RTempRec2.Delete(false);
    //         until L_RTempRec2.Next() = 0;


    //     L_RProdOrderLine.SetRange(Status, L_RProdOrderLine.Status::Released);
    //     F_CalcFeasibility(L_RProdOrderLine, L_RTempRec, L_RTempRSubcFeas1);

    //     if BIncludeFirmPlanned then begin
    //         L_RProdOrderLine.SetRange(Status, L_RProdOrderLine.Status::"Firm Planned");
    //         F_CalcFeasibility(L_RProdOrderLine, L_RTempRec, L_RTempRSubcFeas1);
    //     end;

    //     //Inserisco gli ordini di produzione che ho ricalcolato
    //     L_RTempRec.Reset();
    //     if L_RTempRec.FindSet() then
    //         repeat
    //             L_RTempRec2 := L_RTempRec;
    //             L_RTempRec2.Insert();
    //             //Inserisco i componenti dell'ordine di produzione
    //             L_RTempRSubcFeas1.FilterComponentByProdOrder(L_RTempRec);
    //             if L_RTempRSubcFeas1.FindSet() then
    //                 repeat
    //                     L_RTempRSubcFeas1_2 := L_RTempRSubcFeas1;
    //                     L_RTempRSubcFeas1_2.Insert();
    //                 until L_RTempRSubcFeas1.Next() = 0;
    //         until L_RTempRec.Next() = 0;

    //     //TODO fare eliminazione delle informazioni contenute dei dizionari di drill down
    //     // ProdOrderNoForDrillDownInternalQtyUsedByOtherPerProdOrder, ProdOrderNoForDrillDownExternalQtyUsedByOtherPerProdOrder : Dictionary of [Text, Dictionary of [Code[30], Dictionary of [Code[10], Text]]]; // Nr. ODP, Nr. articolo + Cod. variante, Cod. ubicazione, lista Nr. ODP
    //     // ProdOrderNoForDrillDownInternalQtyUsedByOther, ProdOrderNoForDrillDownExternalQtyUsedByOther : Dictionary of [Code[30], Dictionary of [Code[10], Text]]; // Nr. articolo + Cod. variante, Cod. ubicazione, lista Nr. ODP

    //     Clear(ProdOrderNoForDrillDownInternalQtyUsedByOtherPerProdOrder);
    //     Clear(ProdOrderNoForDrillDownExternalQtyUsedByOtherPerProdOrder);
    //     Clear(ProdOrderNoForDrillDownInternalQtyUsedByOther);
    //     Clear(ProdOrderNoForDrillDownExternalQtyUsedByOther);
    //     L_RTempRec2.Reset();
    //     L_RTempRSubcFeas1_2.reset;
    //     L_RTempRec2.SetCurrentKey("Status Order", "Due Date", "Prod. Order No.", "Line No.");
    //     if L_RTempRec2.FindSet() then
    //         repeat
    //             L_RTempRSubcFeas1_2.FilterComponentByProdOrder(L_RTempRec2);
    //             if L_RTempRSubcFeas1_2.FindSet() then
    //                 repeat
    //                     L_ProdOrderString := '';
    //                     if L_RTempRSubcFeas1_2."Subc. Qty. used Other (Base)" > 0 then
    //                         if F_GetEntryFromProdOrderDictionary(L_ProdOrderString, ProdOrderNoForDrillDownExternalQtyUsedByOther, L_RTempRSubcFeas1_2, L_RTempRSubcFeas1_2."External Location") then
    //                             F_AddEntryInProdOrderDictionaryPerProdOrder(ProdOrderNoForDrillDownExternalQtyUsedByOtherPerProdOrder, L_RTempRSubcFeas1_2, L_ProdOrderString, L_RTempRSubcFeas1_2."External Location");
    //                     if (L_RTempRSubcFeas1_2."Remaining Qty. (Base)" > 0) and (L_RTempRSubcFeas1_2."External Inventory" > L_RTempRSubcFeas1_2."Subc. Qty. used Other (Base)") then
    //                         F_AddEntryInProdOrderDictionary(ProdOrderNoForDrillDownExternalQtyUsedByOther, L_RTempRSubcFeas1_2, L_RTempRSubcFeas1_2."External Location");

    //                     L_ProdOrderString := '';
    //                     if L_RTempRSubcFeas1_2."Int. Qty. used Other (Base)" > 0 then
    //                         if F_GetEntryFromProdOrderDictionary(L_ProdOrderString, ProdOrderNoForDrillDownInternalQtyUsedByOther, L_RTempRSubcFeas1_2, L_RTempRSubcFeas1_2."Internal Location") then
    //                             F_AddEntryInProdOrderDictionaryPerProdOrder(ProdOrderNoForDrillDownInternalQtyUsedByOtherPerProdOrder, L_RTempRSubcFeas1_2, L_ProdOrderString, L_RTempRSubcFeas1_2."Internal Location");
    //                     if (L_RTempRSubcFeas1_2."Remaining Qty. (Base)" > 0) and (L_RTempRSubcFeas1_2."Internal Inventory" > L_RTempRSubcFeas1_2."Int. Qty. used Other (Base)") then
    //                         F_AddEntryInProdOrderDictionary(ProdOrderNoForDrillDownInternalQtyUsedByOther, L_RTempRSubcFeas1_2, L_RTempRSubcFeas1_2."Internal Location");
    //                 until L_RTempRSubcFeas1_2.Next() = 0;
    //         until L_RTempRec2.Next() = 0;

    //     // L_ProdOrderString := '';
    //     // if V_RTempSubcFeasibility1."Subc. Qty. used Other (Base)" > 0 then
    //     //     if F_GetEntryFromProdOrderDictionary(L_ProdOrderString, ProdOrderNoForDrillDownExternalQtyUsedByOther, V_RTempSubcFeasibility1, V_RTempSubcFeasibility1."External Location") then
    //     //         F_AddEntryInProdOrderDictionaryPerProdOrder(ProdOrderNoForDrillDownExternalQtyUsedByOtherPerProdOrder, V_RTempSubcFeasibility1, L_ProdOrderString, V_RTempSubcFeasibility1."External Location");
    //     // if (V_RTempSubcFeasibility1."Remaining Qty. (Base)" > 0) and (V_RTempSubcFeasibility1."External Inventory" > V_RTempSubcFeasibility1."Subc. Qty. used Other (Base)") then
    //     //     F_AddEntryInProdOrderDictionary(ProdOrderNoForDrillDownExternalQtyUsedByOther, V_RTempSubcFeasibility1, V_RTempSubcFeasibility1."External Location");




    //     // L_ProdOrderString := '';
    //     // if V_RTempSubcFeasibility1."Int. Qty. used Other (Base)" > 0 then
    //     //     if F_GetEntryFromProdOrderDictionary(L_ProdOrderString, ProdOrderNoForDrillDownInternalQtyUsedByOther, V_RTempSubcFeasibility1, V_RTempSubcFeasibility1."Internal Location") then
    //     //         F_AddEntryInProdOrderDictionaryPerProdOrder(ProdOrderNoForDrillDownInternalQtyUsedByOtherPerProdOrder, V_RTempSubcFeasibility1, L_ProdOrderString, V_RTempSubcFeasibility1."Internal Location");
    //     // if (V_RTempSubcFeasibility1."Remaining Qty. (Base)" > 0) and (V_RTempSubcFeasibility1."Internal Inventory" > V_RTempSubcFeasibility1."Int. Qty. used Other (Base)") then
    //     //     F_AddEntryInProdOrderDictionary(ProdOrderNoForDrillDownInternalQtyUsedByOther, V_RTempSubcFeasibility1, V_RTempSubcFeasibility1."Internal Location");

    //     // L_RTempRec.SetCurrentKey("Status Order", "Due Date", "Prod. Order No.", "Line No.");
    //     // if L_RTempRec.FindSet() then
    //     //     repeat
    //     //         L_RTempRSubcFeas1.FilterComponentByProdOrder(L_RTempRec);
    //     //         if L_RTempRSubcFeas1.FindSet() then
    //     //             repeat
    //     //                 L_ComponentKey := F_GetComponentKey(L_RTempRSubcFeas1."Item No.", L_RTempRSubcFeas1."Variant Code");
    //     //                 if (L_RTempRec.Status = Rec.Status) and (L_RTempRec."Prod. Order No." = Rec."Prod. Order No.") and (L_RTempRec."Line No." = Rec."Line No.") then begin
    //     //                     L_BMyOrder := true;
    //     //                     //Se sono sul record al quale ho cambiato la "Due Date" devo inserire o rimuovere gli ordini che occupano giacenza in base a se la "Due Date" impostata è maggiore o minore della precedente
    //     //                     L_ProdOrderKey := Rec."Prod. Order No." + Format(Rec."Line No.");
    //     //                     if ProdOrderNoForDrillDownExternalQtyUsedByOtherPerProdOrder.Get(L_ProdOrderKey, L_ProdOrderNoForDrillDownExternalQtyUsedByOther) then
    //     //                         if L_ProdOrderNoForDrillDownExternalQtyUsedByOther.Get(L_ComponentKey, L_ProdOrderNoForDrillDownExtQtyUsedByOtherByLocation) then
    //     //                             if L_ProdOrderNoForDrillDownExtQtyUsedByOtherByLocation.Get(L_RTempRSubcFeas1."External Location", L_ProdOrderDrillDown) then begin
    //     //                                 case true of
    //     //                                     P_OriginalDueDate < P_NewDueDate:
    //     //                                         //Qui vuol dire che l'ODP è stato spostato avanti
    //     //                                         ;
    //     //                                     P_OriginalDueDate > P_NewDueDate:
    //     //                                         //Qui vuol dire che l'ODP è stato spostato indietro
    //     //                                         ;
    //     //                                 end;



    //     //                             end;
    //     //                 end else begin
    //     //                     L_ProdOrderKey := L_RTempRSubcFeas1."Prod. Order No." + Format(L_RTempRSubcFeas1."Prod. Order Line No.");
    //     //                     //Se NON sono sul record al quale ho cambiato la "Due Date" devo inserire o rimuovere dagli ordini che occupano giacenza l'ordine a cui ho modifica "Due Date".
    //     //                     if ProdOrderNoForDrillDownExternalQtyUsedByOtherPerProdOrder.Get(L_ProdOrderKey, L_ProdOrderNoForDrillDownExternalQtyUsedByOther) then
    //     //                         if L_ProdOrderNoForDrillDownExternalQtyUsedByOther.Get(L_ComponentKey, L_ProdOrderNoForDrillDownExtQtyUsedByOtherByLocation) then
    //     //                             if L_ProdOrderNoForDrillDownExtQtyUsedByOtherByLocation.Get(L_RTempRSubcFeas1."External Location", L_ProdOrderDrillDown) then begin
    //     //                                 L_ProdOrderListDrillDown := L_ProdOrderDrillDown.Split('|');
    //     //                                 if not L_BMyOrder then begin
    //     //                                     if L_ProdOrderListDrillDown.Contains(Rec."Prod. Order No.") then begin
    //     //                                         L_ProdOrderListDrillDown.Remove(Rec."Prod. Order No.");
    //     //                                         L_ProdOrderDrillDown := '';
    //     //                                         foreach L_ProdOrder in L_ProdOrderListDrillDown do begin
    //     //                                             if L_ProdOrderDrillDown = '' then
    //     //                                                 L_ProdOrderDrillDown := L_ProdOrder
    //     //                                             else
    //     //                                                 L_ProdOrderDrillDown += '|' + L_ProdOrder;
    //     //                                         end;
    //     //                                     end;



    //     //                                 end else begin
    //     //                                     if not L_ProdOrderListDrillDown.Contains(Rec."Prod. Order No.") then begin
    //     //                                         //TODO Qui metto il mio ODP come ultimo, capire se è meglio metterlo nell'ordine giusto
    //     //                                         if L_ProdOrderDrillDown = '' then
    //     //                                             L_ProdOrderDrillDown := Rec."Prod. Order No."
    //     //                                         else
    //     //                                             L_ProdOrderDrillDown += '|' + Rec."Prod. Order No.";
    //     //                                     end;
    //     //                                 end;
    //     //                                 L_ProdOrderNoForDrillDownExtQtyUsedByOtherByLocation.Set(L_RTempRSubcFeas1_2."External Location", L_ProdOrderDrillDown);
    //     //                                 L_ProdOrderNoForDrillDownExternalQtyUsedByOther.Set(L_ComponentKey, L_ProdOrderNoForDrillDownExtQtyUsedByOtherByLocation);
    //     //                                 ProdOrderNoForDrillDownExternalQtyUsedByOtherPerProdOrder.Set(L_ProdOrderKey, L_ProdOrderNoForDrillDownExternalQtyUsedByOther);
    //     //                             end;
    //     //                 end;
    //     //             until L_RTempRSubcFeas1.Next() = 0;
    //     //     until L_Rtemprec.next = 0;
    // end;

    #region Lookup
    local procedure F_LookupItemNo(var V_Text: Text) O_BResult: Boolean
    var
        L_RItem: Record Item;
        L_FItemList: Page "Item List";
        L_BIsHandled: Boolean;
    begin
        L_RItem.FilterGroup(20);
        L_RItem.SetRange(Type, L_RItem.Type::Inventory);
        L_RItem.SetRange("Production Blocked", L_RItem."Production Blocked"::" ");
        L_RItem.SetRange(Blocked, false);
        L_RItem.FilterGroup(0);
        L_RItem.SetFilter("Routing No.", '<>%1', '');
        L_RItem.SetFilter("Production BOM No.", '<>%1', '');
        L_RItem."No." := CopyStr(V_Text, 1, MaxStrLen(L_RItem."No."));
        L_BIsHandled := false;
        OnLookupItemAfterFilter(L_RItem, V_Text, O_BResult, L_BIsHandled);
        if L_BIsHandled then
            exit(O_BResult);
        L_FItemList.SetTableView(L_RItem);
        L_FItemList.SetRecord(L_RItem);
        L_FItemList.LookupMode := true;
        if L_FItemList.RunModal() <> Action::LookupOK then
            exit(false);
        V_Text := L_FItemList.GetSelectionFilter();
        exit(true);
    end;

    local procedure F_LookupSubcontractorNo(var V_Text: Text) O_BResult: Boolean
    var
        L_RWorkCenter: Record "Work Center";
        L_FWorkCenterList: Page "Work Center List";
        L_BIsHandled: Boolean;
        L_RecRef: RecordRef;
    begin
        L_RWorkCenter.FilterGroup(20);
        L_RWorkCenter.SetFilter("Subcontractor No.", '<>%1', '');
        L_RWorkCenter.FilterGroup(0);
        L_RWorkCenter."No." := CopyStr(V_Text, 1, MaxStrLen(L_RWorkCenter."No."));
        L_BIsHandled := false;
        OnLookupSubcontractorAfterFilter(L_RWorkCenter, V_Text, O_BResult, L_BIsHandled);
        if L_BIsHandled then
            exit(O_BResult);
        L_FWorkCenterList.SetTableView(L_RWorkCenter);
        L_FWorkCenterList.SetRecord(L_RWorkCenter);
        L_FWorkCenterList.LookupMode := true;
        if L_FWorkCenterList.RunModal() <> Action::LookupOK then
            exit(false);
        L_FWorkCenterList.SetSelectionFilter(L_RWorkCenter);
        L_RecRef.GetTable(L_RWorkCenter);
        V_Text := CSelectionFilterMgt.GetSelectionFilter(L_RecRef, L_RWorkCenter.FieldNo("No."));
        exit(true);
    end;

    local procedure F_LookupStandardTaskCode(var V_Text: Text) O_BResult: Boolean
    var
        L_RStandardTask: Record "Standard Task";
        L_FStandardTaskList: Page "Standard Tasks";
        L_BIsHandled: Boolean;
        L_RecRef: RecordRef;
    begin
        L_RStandardTask.Code := CopyStr(V_Text, 1, MaxStrLen(L_RStandardTask.Code));
        L_BIsHandled := false;
        OnLookupStandardTaskCodeOnBeforeRunPage(L_RStandardTask, V_Text, O_BResult, L_BIsHandled);
        if L_BIsHandled then
            exit(O_BResult);
        L_FStandardTaskList.SetTableView(L_RStandardTask);
        L_FStandardTaskList.SetRecord(L_RStandardTask);
        L_FStandardTaskList.LookupMode := true;
        if L_FStandardTaskList.RunModal() <> Action::LookupOK then
            exit(false);
        L_FStandardTaskList.SetSelectionFilter(L_RStandardTask);
        L_RecRef.GetTable(L_RStandardTask);
        V_Text := CSelectionFilterMgt.GetSelectionFilter(L_RecRef, L_RStandardTask.FieldNo(Code));
        exit(true);
    end;

    ///<remarks>Funzione simile a F_LookupItemNo ma fatta in modo da avere un evento a parte e perché non voglio far inserire più di un nr. articolo alla volta come filtro.</remarks>
    local procedure F_LookupComponentItemNo(var V_Text: Text) O_BResult: Boolean
    var
        L_RItem: Record Item;
        L_BIsHandled: Boolean;
    begin
        L_RItem.FilterGroup(20);
        L_RItem.SetRange(Type, L_RItem.Type::Inventory);
        L_RItem.SetRange("Production Blocked", L_RItem."Production Blocked"::" ");
        L_RItem.SetRange(Blocked, false);
        L_RItem.FilterGroup(0);
        L_RItem."No." := CopyStr(V_Text, 1, MaxStrLen(L_RItem."No."));
        L_BIsHandled := false;
        OnLookupComponentItemNoAfterFilter(L_RItem, V_Text, O_BResult, L_BIsHandled);
        if L_BIsHandled then
            exit(O_BResult);
        if Page.RunModal(Page::"Item List", L_RItem) <> Action::LookupOK then
            exit(false);
        V_Text := L_RItem."No.";
        exit(true);
    end;

    local procedure F_LookupVariantCode(var V_Text: Text; P_ItemNo: Code[20]) O_BResult: Boolean
    var
        L_RItemVariant: Record "Item Variant";
        L_BIsHandled: Boolean;
        L_RecRef: RecordRef;
    begin
        if P_ItemNo = '' then
            exit(false);
        L_RItemVariant.SetRange("Item No.", P_ItemNo);
        if L_RItemVariant.IsEmpty then
            exit(false);
        L_RItemVariant.Code := CopyStr(V_Text, 1, MaxStrLen(L_RItemVariant.Code));
        L_RItemVariant."Item No." := CopyStr(P_ItemNo, 1, MaxStrLen(L_RItemVariant."Item No."));
        L_BIsHandled := false;
        OnLookupVariantCodeAfterFilter(L_RItemVariant, V_Text, O_BResult, L_BIsHandled);
        if L_BIsHandled then
            exit(O_BResult);
        if Page.RunModal(Page::"Item Variants", L_RItemVariant) <> Action::LookupOK then
            exit(false);
        V_Text := L_RItemVariant.Code;
        exit(true);
    end;
    #endregion

    local procedure F_CreateProdOrderFilterFromComponentFilter(var V_ProdOrderNoFilter: Text)
    var
        L_RProdOrdComp: Record "Prod. Order Component";
        L_RecRef: RecordRef;
    begin
        V_ProdOrderNoFilter := '';
        if BIncludeFirmPlanned then
            L_RProdOrdComp.SetRange(Status, L_RProdOrdComp.Status::"Firm Planned", L_RProdOrdComp.Status::Released)
        else
            L_RProdOrdComp.SetRange(Status, L_RProdOrdComp.Status::Released);
        L_RProdOrdComp.SetRange("Item No.", ItemNoComponentFilter);
        if VariantCodeComponentFilter <> '' then
            L_RProdOrdComp.SetRange("Variant Code", VariantCodeComponentFilter);
        if L_RProdOrdComp.FindSet() then
            repeat
                if V_ProdOrderNoFilter = '' then
                    V_ProdOrderNoFilter := L_RProdOrdComp."Prod. Order No."
                else
                    V_ProdOrderNoFilter += '|' + L_RProdOrdComp."Prod. Order No.";
            until L_RProdOrdComp.Next() = 0;
    end;

    procedure FilterProdOrderLineForExpectedReceiptQty(var V_RProdOrderLine: Record "Prod. Order Line"; P_ItemNo: Code[20]; P_VariantCode: Code[10]; P_InternalLocatioCode: Code[10])
    begin
        //Key5
        V_RProdOrderLine.SetCurrentKey(Status, "Item No.", "Variant Code", "Location Code", "Due Date");
        V_RProdOrderLine.SetRange(Status, V_RProdOrderLine.Status::Simulated, V_RProdOrderLine.Status::Released);
        V_RProdOrderLine.SetRange("Item No.", P_ItemNo);
        V_RProdOrderLine.SetRange("Variant Code", P_VariantCode);
        V_RProdOrderLine.SetRange("Location Code", P_InternalLocatioCode);
        V_RProdOrderLine.SetFilter("Remaining Qty. (Base)", '>%1', 0);
    end;

    procedure FilterPurchaseLineForExpectedReceiptQty(var V_RPurchaseLine: Record "Purchase Line"; P_ItemNo: Code[20]; P_VariantCode: Code[10]; P_InternalLocatioCode: Code[10])
    begin
        //Key3
        V_RPurchaseLine.SetCurrentKey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Expected Receipt Date");
        V_RPurchaseLine.SetRange("Document Type", V_RPurchaseLine."Document Type"::Order);
        V_RPurchaseLine.SetRange(Type, V_RPurchaseLine.Type::Item);
        V_RPurchaseLine.SetRange("No.", P_ItemNo);
        V_RPurchaseLine.SetRange("Variant Code", P_VariantCode);
        V_RPurchaseLine.SetRange("Location Code", P_InternalLocatioCode);
        V_RPurchaseLine.SetFilter("Outstanding Qty. (Base)", '>%1', 0);
    end;

    procedure FilterProdOrderLineForExpectedReceiptQty(var V_RAssemblyHeader: Record "Assembly Header"; P_ItemNo: Code[20]; P_VariantCode: Code[10]; P_InternalLocatioCode: Code[10])
    begin
        //Key2
        V_RAssemblyHeader.SetCurrentKey("Document Type", "Item No.", "Variant Code", "Location Code", "Due Date");
        V_RAssemblyHeader.SetRange("Document Type", V_RAssemblyHeader."Document Type"::Order);
        V_RAssemblyHeader.SetRange("Item No.", P_ItemNo);
        V_RAssemblyHeader.SetRange("Variant Code", P_VariantCode);
        V_RAssemblyHeader.SetRange("Location Code", P_InternalLocatioCode);
        V_RAssemblyHeader.SetFilter("Remaining Quantity (Base)", '>%1', 0);
    end;

    local procedure F_GetExpectedReceiptQty(P_ItemNo: Code[20]; P_VariantCode: Code[10]; P_InternalLocatioCode: Code[10]) O_Qty: Decimal
    var
        L_RProdOrderLine: Record "Prod. Order Line";
        L_RPurchaseLine: Record "Purchase Line";
        L_RAssemblyHeader: Record "Assembly Header";
        L_ComponentKey: Code[30];
    begin
        L_ComponentKey := F_GetComponentKey(P_ItemNo, P_VariantCode);
        if ExpectedReceiptQtyForComponent.Get(L_ComponentKey, O_Qty) then
            exit;

        //Ordini di produzione
        FilterProdOrderLineForExpectedReceiptQty(L_RProdOrderLine, P_ItemNo, P_VariantCode, P_InternalLocatioCode);
        if not L_RProdOrderLine.IsEmpty() then
            L_RProdOrderLine.CalcSums("Remaining Qty. (Base)");

        //Ordini di acquisto
        FilterPurchaseLineForExpectedReceiptQty(L_RPurchaseLine, P_ItemNo, P_VariantCode, P_InternalLocatioCode);
        if not L_RPurchaseLine.IsEmpty() then
            L_RPurchaseLine.CalcSums("Outstanding Qty. (Base)");

        //Ordini di assemblaggio
        FilterProdOrderLineForExpectedReceiptQty(L_RAssemblyHeader, P_ItemNo, P_VariantCode, P_InternalLocatioCode);
        if not L_RAssemblyHeader.IsEmpty() then
            L_RAssemblyHeader.CalcSums("Remaining Quantity (Base)");

        O_Qty := (L_RProdOrderLine."Remaining Qty. (Base)" + L_RPurchaseLine."Outstanding Qty. (Base)" + L_RAssemblyHeader."Remaining Quantity (Base)");
        ExpectedReceiptQtyForComponent.Add(L_ComponentKey, O_Qty);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnLookupItemAfterFilter(var Item: Record Item; var Text: Text; var LookupResult: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnLookupSubcontractorAfterFilter(var WorkCenter: Record "Work Center"; var Text: Text; var LookupResult: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnLookupStandardTaskCodeOnBeforeRunPage(var StandardTask: Record "Standard Task"; var Text: Text; var LookupResult: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnLookupComponentItemNoAfterFilter(var Item: Record Item; var Text: Text; var LookupResult: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnLookupVariantCodeAfterFilter(var ItemVariant: Record "Item Variant"; var Text: Text; var LookupResult: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcFeasibilityOnAfterSetFilterOnProdOrderLine(var Rec: Record "TMP Subc. Feasibility PTE" temporary; var ProdOrderLine: Record "Prod. Order Line"; var TempRSubcFeas1: Record "TMP Subc. Feasibility 1 PTE" temporary; IncludeFirmPlannedProdOrder: Boolean; ItemComponentNoFilter: Code[20]; VariantComponentCode: Code[10]; var IsHandled: Boolean)
    begin
    end;

    //TODO da fare per queste page:

    // - Carino da fare il filtro per componente. Quindi carico solo gli ODP con il componente specificato e mostro solo quello
    // - sistemare anche questa pagina vedendo i campi in plastiape
    // - da fare una funzionalità che controlla anche le quantità che verranno prodotte in futuro, nel senso che magari mi servono 100 pezzo ma ne ho 80 in magazzino perciò risulta non fattibile, però ho un ordine di acquisto di 100 che arriva tra 5 giorni, perciò li poi sarà fattibile
    // - capire che azioni mettere nella page
    // - la page "Subcontactor Feasibility 2 PTE" capire se si riesce a fare un altro modo invece che avere una page part, vedere se fare che quando ti posizioni sull componente ti evidenzia gli ODP in cui è usato, però questa soluzione non so se è la migliore
    // - Rendere ben visibili quali sono i componenti che impediscono la fattibilità dell'ODP
    // - I nomi dei campi renderli più capibili
}