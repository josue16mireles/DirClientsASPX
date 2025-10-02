<%@ Page Title="" Language="C#" MasterPageFile="~/Root.master" AutoEventWireup="true" CodeBehind="Client_Edit.aspx.cs" Inherits="dir_clients.Client_Edit" %>

<%@ Register Assembly="DevExpress.Web.v23.2, Version=23.2.13.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>

<asp:Content ContentPlaceHolderID="Head" runat="server">
    <link rel="stylesheet" type="text/css" href='<%# ResolveUrl("~/Content/GridView.css") %>' />

    <script type="text/javascript">
        var currentFilter = "Active"; // sirve para activar la edición cuando no este en filtro vencidas o canceladas
        let uidPolizaSeleccionada = null; //guarda el uid_poliza para el proceso de cancelación
        let number_poliza = null; //numero de poliza a cancelar

        function onGridViewInit(s, e) {
            AddAdjustmentDelegate(adjustGridView);
            updateToolbarButtonsState();
            AdjustSize(); //ajusta el tamaño del grid segun el tamaño de la pantalla

        }
        function AdjustSize() {
            var height = Math.max(0, document.documentElement.clientHeight);
            gridView.SetHeight(height);
        }

        function onGridViewSelectionChanged(s, e) {
            updateToolbarButtonsState();
        }
        function adjustGridView() {
            gridView.AdjustControl();
        }
        function updateToolbarButtonsState() {
            var enabled = gridView.GetSelectedRowCount() > 0;
            pageToolbar.GetItemByName("Export").SetEnabled(enabled);

            // Solo habilitar el botón si el filtro lo permite
            var editButton = pageToolbar.GetItemByName("Edit");
            if (currentFilter === "Vencida" || currentFilter === "Cancelada") {
                editButton.SetEnabled(false);
            } else {
                editButton.SetEnabled(gridView.GetFocusedRowIndex() !== -1);
            }

        }
        function onPageToolbarItemClick(s, e) {
            switch (e.item.name) {
                case "ToggleFilterPanel":
                    toggleFilterPanel();
                    break;
                case "Save":
                    if (!(HasChanges()))
                        return;
                    _savecancel(true);
                    break;
                case "Cancel":
                    if (HasChanges()) {
                        _savecancel(false);
                    }
                    else {
                        return;
                    }
                    break;
                case "New":
                    gridView.AddNewRow();
                    break;
                case "Edit":
                    gridView.StartEditRow(gridView.GetFocusedRowIndex());
                    break;
                case "Delete":
                    var rowIndex = gridView.GetFocusedRowIndex();
                    if (rowIndex < 0) {
                        alert("Por favor, selecciona una póliza antes de cancelar.");
                        break;
                    }

                    // Obtener el UID directamente desde la clave primaria
                    uidPolizaSeleccionada = gridView.GetRowKey(rowIndex);

                    // Limpiar el campo de texto antes de mostrar el popup
                    txtCancelReason.SetText("");

                    var polizaSeleccionada = gridView.GetRowValues(gridView.GetFocusedRowIndex(), 'no_poliza', function (value) {
                        if (!value || value.length < 1) {
                            alert("No se pudieron obtener el número de la póliza.");
                            return;
                        }
                        lblCancelReason.SetText("Motivo de cancelación de la póliza: " + value);
                        number_poliza = value;
                        popupCancelPol.Show();
                    });
                    break;
                case "Export":
                    gridView.ExportTo(ASPxClientGridViewExportFormat.Xlsx);
                    break;
            }
        }
        function onFiltersNavBarItemClick(s, e) {
            var filters = {
                All: "",
                Active: "[estatus] = 'activa' ",
                Vencida: "[estatus] = 'vencida' ",
                Cancelada: "[estatus] = 'cancelada' ",

            };

            currentFilter = e.item.name; // guarda el filtro actual

            // Deselecciona todas las filas seleccionadas
            gridView.UnselectAllRowsOnPage();

            //gridView.ApplyFilter(filters[e.item.name]);
            gridView.PerformCallback(currentFilter); // Llama al servidor para ajustar columnas


            // Deshabilita el botón "Editar" si el filtro es Vencida o Cancelada
            var editButton = pageToolbar.GetItemByName("Edit");
            if (currentFilter === "Vencida" || currentFilter === "Cancelada") {
                editButton.SetEnabled(false);
            } else {
                editButton.SetEnabled(true);
            }

            // Deshabilita el botón "Cancelar Pol" si el filtro es Vencida o Cancelada
            var cancelPolButton = pageToolbar.GetItemByName("Delete");
            if (currentFilter === "Vencida" || currentFilter === "Cancelada") {
                cancelPolButton.SetEnabled(false);
            } else {
                cancelPolButton.SetEnabled(true);
            }

            HideLeftPanelIfRequired();
        }
        function toggleFilterPanel() {
            filterPanel.Toggle();
        }

        function onFilterPanelExpanded(s, e) {
            adjustPageControls();
            searchButtonEdit.SetFocus();
        }
        /**PARA GUARDAR O LIMPIAR CAMBIOS DE CARDVIEW Y GRIDVIEW EN EL Client_Edit**/
        function HasChanges() {
            return (cvClientEdit.batchEditApi.HasChanges() || gridView.batchEditApi.HasChanges());
        }
        function _savecancel(_cambios) {
            if (_cambios) {
                cvClientEdit.UpdateEdit();
                gridView.UpdateEdit();
            } else {
                cvClientEdit.CancelEdit();
                gridView.CancelEdit();
            }
        }
        function OnEndCallback(s, e) {
            if (!HasChanges()) {
            }
            lastEditedCpy = -1;
        }
        /**PARA GUARDAR O LIMPIAR CAMBIOS DE CARDVIEW Y GRIDVIEW EN EL Client_Edit**/

        /**FILTRA EL COMBOBOX DE PRODUCTO CONFORME A LA SELECCION DEL COMBOBOX COMPANY**/
        var currentRowIndex = -1;
        var currentColumnIndex = -1;
        var lastEditedCpy = -1;

        function onBatchEditStartEditing(s, e) {
            // Bloquear edición si el filtro activo es Vencida o Cancelada
            if (currentFilter === "Vencida" || currentFilter === "Cancelada") {
                e.cancel = true;
                return;
            }

            currentRowIndex = e.visibleIndex;
            currentColumnIndex = e.focusedColumn.index;
            var currentCpy = s.batchEditApi.GetCellValue(currentRowIndex, "uid_company");
            if (currentCpy != lastEditedCpy && e.focusedColumn.fieldName == "uid_product") {
                lastEditedCpy = currentCpy;
                e.cancel = true;
                cmbProd.PerformCallback(lastEditedCpy);
            }
        }
        function onSelectedCpyChanged(s, e) {
            lastEditedCpy = s.GetValue();
            gridView.batchEditApi.SetCellValue(currentRowIndex, "uid_product", null);
            cmbProd.PerformCallback(s.GetValue());
        }
        function onFocusedCellChanging(s, e) {
            e.cancel = cmbProd.InCallback();
        }
        function onProdEndCallback(s, e) {
            lp.Hide();
            gridView.batchEditApi.StartEdit(currentRowIndex, currentColumnIndex);
        }
        function onBeginCallback(s, e) {
            window.setTimeout(function () {
                if (cmbProd.InCallback()) lp.ShowInElement(gridView.batchEditApi.GetCellTextContainer(currentRowIndex, "uid_product"));
            }, 300);
        }
        /**FILTRA EL COMBOBOX DE PRODUCTO CONFORME A LA SELECCION DEL COMBOBOX COMPANY**/


        /**CANCELAR POLIZAS**/
        function cancelarPoliza() {
            const nota = txtCancelReason.GetText();

            if (!nota) {
                alert("Por favor, ingresa el motivo de cancelación.");
                return;
            }

            // Aquí deberías tener seleccionado el UID de la póliza que se quiere cancelar
            if (!uidPolizaSeleccionada) {
                alert("No se pudo obtener la póliza seleccionada.");
                return;
            }

            $.ajax({
                type: "POST",
                url: "Client_Edit.aspx/CancelarPoliza",
                data: JSON.stringify({ uidPoliza: uidPolizaSeleccionada, nota: nota }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "OK") {
                        alert("Póliza " + number_poliza + " cancelada correctamente.");
                        popupCancelPol.Hide();
                        // Refrescar el grid
                        gridView.Refresh();
                        currentFilter = "Cancelada"; // Actualiza el filtro actual
                        PerformCallback(currentFilter);
                    } else {
                        alert(response.d);
                    }
                },
                error: function (err) {
                    alert("Error en la llamada: " + err.responseText);
                }
            });
        }
        /**CANCELAR POLIZAS**/
    </script>
</asp:Content>
<asp:Content ContentPlaceHolderID="LeftPanelContent" runat="server">
    
     <h3 class="leftpanel-section section-caption">Filtros</h3>
    <dx:ASPxNavBar runat="server" ID="FiltersNavBar" ClientInstanceName="filtersNavBar"
        AllowSelectItem="true" ShowGroupHeaders="false"
        Width="100%" CssClass="filters-navbar">
        <ItemStyle CssClass="item" />
        <Groups>
            <dx:NavBarGroup>
                <Items>
                    <dx:NavBarItem Text="Polizas activas" Selected="true" Name="Active" />
                    <dx:NavBarItem Text="Polizas vencidas" Name="Vencida" />
                    <dx:NavBarItem Text="Polizas canceladas" Name="Cancelada" />
                </Items>
            </dx:NavBarGroup>
        </Groups>
        <ClientSideEvents ItemClick="onFiltersNavBarItemClick" />
    </dx:ASPxNavBar>
</asp:Content>
<asp:Content ContentPlaceHolderID="PageToolbar" runat="server">
    <dx:ASPxMenu runat="server" ID="PageToolbar" ClientInstanceName="pageToolbar"
        ItemAutoWidth="false" ApplyItemStyleToTemplates="true" ItemWrap="false"
        AllowSelectItem="false" SeparatorWidth="0"
        Width="100%" CssClass="page-toolbar">
        <ClientSideEvents ItemClick="onPageToolbarItemClick" />
        <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="true"
            EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="600" />
        <ItemStyle CssClass="item" VerticalAlign="Middle" />
        <ItemImage Width="16px" Height="16px" />
        <Items>
            <dx:MenuItem Enabled="false">
                <Template>
                    <h1>Cliente</h1>
                </Template>
            </dx:MenuItem> 
            <dx:MenuItem Name="Save" Text="Guardar" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/save.svg" />
            </dx:MenuItem>
             <dx:MenuItem Name="Cancel" Text="Cancelar" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/cancel.svg" />
            </dx:MenuItem>
            <dx:MenuItem Name="New" Text="Nuevo" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/add.svg" />
            </dx:MenuItem>
            <dx:MenuItem Name="Edit" Text="Editar" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/edit.svg" />
            </dx:MenuItem>
             <dx:MenuItem Name="Delete" Text="Cancelar Pol." Alignment="Right" AdaptivePriority="2">
                 <Image Url="Content/Images/delete.svg" />
             </dx:MenuItem>
            <dx:MenuItem Name="Export" Text="Exportar" Alignment="Right" AdaptivePriority="2">
                <Image Url="Content/Images/export.svg" />
            </dx:MenuItem>
        </Items>
    </dx:ASPxMenu>
    <dx:ASPxPanel runat="server" ID="FilterPanel" ClientInstanceName="filterPanel" Collapsible="True" CssClass="filter-panel">
        <SettingsCollapsing ExpandEffect="PopupToBottom" AnimationType="Fade" ExpandButton-Visible="false" />
        <PanelCollection>
            <dx:PanelContent>
                <dx:ASPxButtonEdit runat="server" ID="SearchButtonEdit" ClientInstanceName="searchButtonEdit" ClearButton-DisplayMode="Always" Caption="Search" Width="100%" />
            </dx:PanelContent>
        </PanelCollection>
        <ClientSideEvents Expanded="onFilterPanelExpanded" Collapsed="adjustPageControls" />
    </dx:ASPxPanel>
</asp:Content>

<asp:Content ID="Content" ContentPlaceHolderID="PageContent" runat="server">

    <dx:ASPxPopupControl ID="popupCancelPol" runat="server" ClientInstanceName="popupCancelPol"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
        CloseAction="CloseButton" ShowCloseButton="false" Width="400px" HeaderText="Cancelación de Pólizas">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <dx:ASPxLabel ID="lblCancelReason" runat="server" ClientInstanceName="lblCancelReason" Text="Motivo de cancelación de la póliza: " Font-Bold="true" />
                <dx:ASPxMemo ID="txtCancelReason" ClientInstanceName="txtCancelReason" runat="server" Width="100%" Height="100px" />
                <br />
            
                <div style="display: flex; justify-content: flex-end; gap: 10px; margin-top: 10px;">

                    <dx:ASPxButton ID="btnConfirmCancel" runat="server" Text="Confirmar Cancelación" AutoPostBack="false">
                        <ClientSideEvents Click="function(s, e) { 
                            cancelarPoliza();
                            popupCancelPol.Hide();
                        }" />
                    </dx:ASPxButton>
                    <dx:ASPxButton ID="btnCerrarPopup" runat="server" Text="Cerrar" AutoPostBack="false">
                        <ClientSideEvents Click="function(s, e) { popupCancelPol.Hide(); }" />
                    </dx:ASPxButton>
                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>

    <dx:ASPxLoadingPanel runat="server" ID="loadingPanel" ClientInstanceName="lp" Modal="true" />
    <dx:ASPxFormLayout ID="ASPxFormLayout1" runat="server" UseDefaultPaddings="False">
        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" GridSettings-StretchLastItem="True">
            <GridSettings StretchLastItem="True"></GridSettings>
        </SettingsAdaptivity>
        <Items>
            <dx:LayoutItem ColSpan="1" HorizontalAlign="Center" ShowCaption="False">
                <LayoutItemNestedControlCollection>
                    <dx:LayoutItemNestedControlContainer runat="server">
                         <dx:EntityServerModeDataSource ID="esmdClient" runat="server" OnSelecting="esmdClient_Selecting" OnUpdating="esmdClient_Updating" />
                         <dx:ASPxCardView ID="cvClientEdit" ClientInstanceName="cvClientEdit" runat="server" 
                            DataSourceID="esmdClient" KeyFieldName="uid_client" AutoGenerateColumns="False"
                            OnCardUpdating="cvClientEdit_CardUpdating" OnCustomErrorText="cvClientEdit_CustomErrorText" Border-BorderStyle="Solid">
                            <ClientSideEvents EndCallback="OnEndCallback" />
                            <SettingsPager Visible="False"/>
                            <SettingsEditing Mode="Batch">
                                <BatchEditSettings EditMode="Card" StartEditAction="DblClick" />
                            </SettingsEditing>
                            <Settings LayoutMode="Flow" ShowStatusBar="Hidden"/>
                            <SettingsAdaptivity>
                                <BreakpointsLayoutSettings CardsPerRow="1" >
                                </BreakpointsLayoutSettings>
                            </SettingsAdaptivity>
                            <SettingsCommandButton>
                                <UpdateButton Text=" "/>
                                <CancelButton Text=" "/>
                            </SettingsCommandButton>
                            <SettingsDataSecurity AllowInsert="False" AllowReadUnlistedFieldsFromClientApi="True" />
                            <SettingsBehavior AllowFocusedCard="true" AllowSelectByCardClick="true" AllowSelectSingleCardOnly="true" />

                            <SettingsExport ExportSelectedCardsOnly="False"/>

                            <Columns>
                                <dx:CardViewTextColumn FieldName="uid_client" ReadOnly="True" Visible="False" VisibleIndex="0">
                                </dx:CardViewTextColumn>
                                <dx:CardViewTextColumn Caption="Nombre" FieldName="nombre" VisibleIndex="1">
                                </dx:CardViewTextColumn>
                                <dx:CardViewTextColumn Caption="Direccion" FieldName="direccion" VisibleIndex="2">
                                </dx:CardViewTextColumn>
                                <dx:CardViewTextColumn Caption="Telefono" FieldName="telefono" VisibleIndex="3">
                                </dx:CardViewTextColumn>
                                <dx:CardViewTextColumn Caption="Celular" FieldName="celular" VisibleIndex="4">
                                </dx:CardViewTextColumn>
                                <dx:CardViewTextColumn Caption="Email" FieldName="email" VisibleIndex="5">
                                </dx:CardViewTextColumn>
                                <dx:CardViewTextColumn Caption="Email 2" FieldName="email2" VisibleIndex="6">
                                </dx:CardViewTextColumn>
                                <dx:CardViewMemoColumn Caption="Relacionado" FieldName="relacionado" VisibleIndex="7">
                                    <PropertiesMemoEdit>
			                            <Style Font-Size="Small" Wrap="True"/>
		                            </PropertiesMemoEdit>
		                            <BatchEditModifiedCellStyle Wrap="False">
		                            </BatchEditModifiedCellStyle>
                                </dx:CardViewMemoColumn>
                                <dx:CardViewMemoColumn Caption="Archivero" FieldName="archivero" VisibleIndex="8">
                                    <PropertiesMemoEdit>
			                            <Style Font-Size="Small" Wrap="True"/>
		                            </PropertiesMemoEdit>
		                            <BatchEditModifiedCellStyle Wrap="False">
		                            </BatchEditModifiedCellStyle>
                                </dx:CardViewMemoColumn>
                            </Columns>

                            <CardLayoutProperties ColCount="4" ColumnCount="4">
                                <Items>
                                    <dx:CardViewColumnLayoutItem Caption="Nombre" ColSpan="1" ColumnName="Nombre" Width="450px">
                                    </dx:CardViewColumnLayoutItem>
                                    <dx:CardViewColumnLayoutItem ColSpan="1" ColumnName="Direccion" Width="450px">
                                    </dx:CardViewColumnLayoutItem>
                                    <dx:CardViewColumnLayoutItem ColSpan="1" ColumnName="Telefono" Width="270px">
                                    </dx:CardViewColumnLayoutItem>
                                    <dx:CardViewColumnLayoutItem ColSpan="1" ColumnName="Relacionado" Width="450px">
                                    </dx:CardViewColumnLayoutItem>
                                    <dx:CardViewColumnLayoutItem ColSpan="1" ColumnName="Email" Width="450px">
                                    </dx:CardViewColumnLayoutItem>
                                    <dx:CardViewColumnLayoutItem ColSpan="1" ColumnName="Email 2" Width="450px">
                                    </dx:CardViewColumnLayoutItem>
                                    <dx:CardViewColumnLayoutItem ColSpan="1" ColumnName="Celular" Width="270px">
                                    </dx:CardViewColumnLayoutItem>
                                    <dx:CardViewColumnLayoutItem ColSpan="1" ColumnName="Archivero" Width="450px">
                                    </dx:CardViewColumnLayoutItem>
                                </Items>
                            </CardLayoutProperties>

                           <Styles>
                                <FlowCard Height="30%" Width="90%" >
                                </FlowCard>
                                <Table HorizontalAlign="Left" VerticalAlign="Top" Wrap="True">
                                    
                                </Table>
                            </Styles>
                            <StylesExport>
                                <Card BorderSize="1" BorderSides="All"></Card>
                                <Group BorderSize="1" BorderSides="All"></Group>
                                <TabbedGroup BorderSize="1" BorderSides="All"></TabbedGroup>
                                <Tab BorderSize="1"></Tab>
                            </StylesExport>

                            <Border BorderStyle="Solid"></Border>
        
                        </dx:ASPxCardView>
                    </dx:LayoutItemNestedControlContainer>
                </LayoutItemNestedControlCollection>
            </dx:LayoutItem>
            <dx:LayoutItem ColumnSpan="1" HorizontalAlign="Center" ShowCaption="False" Width="85%">
                <LayoutItemNestedControlCollection>
                    <dx:LayoutItemNestedControlContainer runat="server">
                        <dx:ASPxCallbackPanel ID="cpGrid" runat="server" Width="100%" ClientInstanceName="cpGrid">
                            <PanelCollection>
                                <dx:PanelContent runat="server">
                                    <dx:EntityServerModeDataSource ID="esmdPolizasClient" runat="server" EnableInsert="true" EnableUpdate="true" OnSelecting="esmdPolizasClient_Selecting" OnInserting="esmdPolizasClient_Inserting" OnUpdating="esmdPolizasClient_Updating"/>
                                    <asp:SqlDataSource ID="dsProduct" runat="server" ConnectionString="<%$ ConnectionStrings:ModelClients %>" SelectCommand="select UID_Principal, uid_company, Producto, uid_product from dbo.vCompany_Products" />
                                    <asp:SqlDataSource ID="dsCpy" runat="server" ConnectionString="<%$ ConnectionStrings:ModelClients %>" SelectCommand="SELECT uid_company, company FROM dbo.vcompany ORDER BY company"/>
                                    
                                    <dx:ASPxLoadingPanel runat="server" ID="ASPxLoadingPanel1" ClientInstanceName="lp" Modal="true" />
                                    <dx:ASPxGridView ID="GridView" runat="server" AutoGenerateColumns="false" ClientInstanceName="gridView" 
                                        DataSourceID="esmdPolizasClient" KeyFieldName="uid_poliza" 
                                        OnCustomCallback="GridView_CustomCallback" OnRowInserting="GridView_RowInserting" 
                                        OnRowUpdating="GridView_RowUpdating" OnCustomErrorText="GridView_CustomErrorText" 
                                        OnCommandButtonInitialize="GridView_CommandButtonInitialize" OnCellEditorInitialize="GridView_CellEditorInitialize" >

                                       <ClientSideEvents Init="onGridViewInit" SelectionChanged="onGridViewSelectionChanged" BatchEditStartEditing="onBatchEditStartEditing" EndCallback="OnEndCallback" FocusedCellChanging="onFocusedCellChanging" /> 

                                        <SettingsResizing ColumnResizeMode="Control" />
                                        <SettingsBehavior AllowFocusedRow="true" AllowSelectByRowClick="true" AllowEllipsisInText="true" AllowDragDrop="false"/>
                                        <SettingsEditing Mode="Batch" UseFormLayout="false" NewItemRowPosition="Bottom">
                                            <BatchEditSettings EditMode="Row" />
                                        </SettingsEditing>   
                                        <Settings VerticalScrollBarMode="auto" VerticalScrollableHeight="620" HorizontalScrollBarMode="Auto" ShowHeaderFilterButton="true"/>
                                        <SettingsPager PageSize="100" EnableAdaptivity="true">
                                            <PageSizeItemSettings Visible="true"></PageSizeItemSettings>
                                        </SettingsPager>
                                        <SettingsCookies StorePaging="False" />
                                        <Styles>
                                            <Cell Wrap="false" />
                                            <PagerBottomPanel CssClass="pager" />
                                            <FocusedRow CssClass="focused" />
                                        </Styles>
                                        <Paddings PaddingTop="0px" />

                                        <Columns>
                                            <dx:GridViewDataTextColumn FieldName="uid_poliza" ShowInCustomizationForm="true" Visible="false" VisibleIndex="1">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="no_poliza" Caption="Poliza" ShowInCustomizationForm="true" Visible="true" VisibleIndex="2" Width="200px">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="Serie" FieldName="serie" VisibleIndex="3" ShowInCustomizationForm="true" Width="180">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataComboBoxColumn Caption="Año" FieldName="ano" VisibleIndex="4" ShowInCustomizationForm="true" Width="70">
                                                <PropertiesComboBox ValueType="System.Int16"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataDateColumn FieldName="fech_inicio" Caption="Fech Ini." ShowInCustomizationForm="true" Visible="true" VisibleIndex="5" Width="200px">
                                            </dx:GridViewDataDateColumn>
                                            <dx:GridViewDataTextColumn FieldName="fech_vencimiento" Caption="Vencimiento" ReadOnly="true" ShowInCustomizationForm="true" Visible="true" VisibleIndex="6" Width="200px">
                                                <PropertiesTextEdit DisplayFormatString="d"></PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="tipo_pago" Caption="Frec. Pago" ShowInCustomizationForm="true" Visible="true" VisibleIndex="7" Width="105px">
                                                <PropertiesComboBox>
                                                    <Items>
                                                        <dx:ListEditItem Text="Mensual" Value="1" />
                                                        <dx:ListEditItem Text="Trimestral" Value="2" />
                                                        <dx:ListEditItem Text="Semestral" Value="3" />
                                                        <dx:ListEditItem Text="Anual" Value="4" />
                                                    </Items>
                                                </PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataTextColumn FieldName="nxt_pago" Caption="Sig. Pago" ReadOnly="true" ShowInCustomizationForm="true" Visible="true" VisibleIndex="8" Width="270px">
                                                 <PropertiesTextEdit DisplayFormatString="d"></PropertiesTextEdit>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataComboBoxColumn Caption="Compañia" FieldName="uid_company" ShowInCustomizationForm="true" Visible="true" VisibleIndex="9" Width="120px">
                                                <PropertiesComboBox ClientInstanceName="cbCpyProd" TextField="company" ValueField="uid_company" ValueType="System.String" EnableSynchronization="false" DataSecurityMode="Strict" 
                                                    IncrementalFilteringMode="StartsWith" DataSourceID="dsCpy">
                                                    <ClientSideEvents SelectedIndexChanged="onSelectedCpyChanged" />
                                                </PropertiesComboBox>            
                                            </dx:GridViewDataComboBoxColumn>
                                             <dx:GridViewDataComboBoxColumn Caption="Producto" FieldName="uid_product" VisibleIndex="10" ShowInCustomizationForm="true" Width="160">
                                                 <PropertiesComboBox EnableSynchronization="false" IncrementalFilteringMode="StartsWith" ClientInstanceName="cmbProd" DataSourceID="dsProduct" TextField="Producto" ValueField="uid_product" ValueType="System.String" DataSecurityMode="Strict" >
                                                     <ClientSideEvents EndCallback="onProdEndCallback" BeginCallback="onBeginCallback" />
                                                 </PropertiesComboBox>
                                             </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataTextColumn Caption="Estatus" FieldName="estatus" VisibleIndex="11" Visible="false" Width="90" >
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="Nota" FieldName="nota" VisibleIndex="12" Visible="false" Width="200" >
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="Evento" FieldName="Evento" ReadOnly="true" VisibleIndex="13" Width="100" Visible="true" >
                                            </dx:GridViewDataTextColumn>
                                        </Columns>

                                    </dx:ASPxGridView>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxCallbackPanel>
                    </dx:LayoutItemNestedControlContainer>
                </LayoutItemNestedControlCollection>
            </dx:LayoutItem>
        </Items>
    </dx:ASPxFormLayout>
</asp:Content>
