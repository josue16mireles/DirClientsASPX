<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NewCpyProd.ascx.cs" Inherits="dir_clients.NewCpyProd" %>
<%@ Register Assembly="DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>
<%--<%@ Register Assembly="DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data.Linq" TagPrefix="dx" %>--%>

    <script type="text/javascript">
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
            }
        }
        function toggleFilterPanel() {
            filterPanel.Toggle();
        }
        function onFilterPanelExpanded(s, e) {
            adjustPageControls();
            searchButtonEdit.SetFocus();
        }
        /**PARA GUARDAR O LIMPIAR CAMBIOS GRIDVIEW **/
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
        /**PARA GUARDAR O LIMPIAR CAMBIOS GRIDVIEW **/
    </script>

<dx:ASPxRoundPanel ID="ASPxRoundPanel1" runat="server" ShowCollapseButton="false" Width="200px"  ShowHeader="False" OnInit="ASPxRoundPanel1_Init">
    <PanelCollection>
        <dx:PanelContent runat="server">
            <dx:ASPxFormLayout  ID="ASPxFormLayout1" runat="server" ColCount="1" >
                <Items>
                    <dx:LayoutGroup ColSpan="1" GroupBoxDecoration="None" ShowCaption="False">
                        <Border BorderStyle="None" />
                            <Items>
                                <dx:LayoutItem ColSpan="1" ShowCaption="False" Width="100%">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server">
                                            <dx:ASPxMenu runat="server" ID="PageToolbar" ClientInstanceName="pageToolbar"
                                                ItemAutoWidth="false" ApplyItemStyleToTemplates="true" ItemWrap="false"
                                                AllowSelectItem="false" SeparatorWidth="0"
                                                Width="100%" CssClass="page-toolbar" EnableCallBacks="true">
                                                <ClientSideEvents ItemClick="onPageToolbarItemClick" />
                                                <ItemStyle CssClass="item" VerticalAlign="Middle" />
                                                <ItemImage Width="16px" Height="16px" />
                                                <Items>
                                                    <dx:MenuItem Name="Save" Text="Guardar" Alignment="Right" AdaptivePriority="2">
                                                        <Image Url="Content/Images/save.svg" />
                                                    </dx:MenuItem>
                                                     <dx:MenuItem Name="Cancel" Text="Cancelar" Alignment="Right" AdaptivePriority="2">
                                                        <Image Url="Content/Images/cancel.svg" />
                                                    </dx:MenuItem>
                                                    <dx:MenuItem Name="New" Text="New" Alignment="Right" AdaptivePriority="2">
                                                        <Image Url="Content/Images/add.svg" />
                                                    </dx:MenuItem>
                                                    <dx:MenuItem Name="Edit" Text="Edit" Alignment="Right" AdaptivePriority="2">
                                                        <Image Url="Content/Images/edit.svg" />
                                                    </dx:MenuItem>
                                                    <%--<dx:MenuItem Name="ToggleFilterPanel" Text="" GroupName="Filter" Alignment="Right" AdaptivePriority="1">
                                                        <Image Url="Content/Images/search.svg" UrlChecked="Content/Images/search-selected.svg" />
                                                    </dx:MenuItem>--%>
                                                </Items>
                                            </dx:ASPxMenu>
                                            <dx:ASPxPanel runat="server" ID="FilterPanel" ClientInstanceName="filterPanel" Collapsible="True" CssClass="filter-panel">
                                                <SettingsCollapsing ExpandEffect="PopupToBottom" AnimationType="Fade" ExpandButton-Visible="false" >
                                                <ExpandButton Visible="False"></ExpandButton>
                                                </SettingsCollapsing>
                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <dx:ASPxButtonEdit runat="server" ID="SearchButtonEdit" ClientInstanceName="searchButtonEdit" ClearButton-DisplayMode="Always" Caption="Search" Width="100%" >
                                                            <ClearButton DisplayMode="Always"></ClearButton>
                                                        </dx:ASPxButtonEdit>
                                                    </dx:PanelContent>
                                                </PanelCollection>
                                                <ClientSideEvents Expanded="onFilterPanelExpanded" Collapsed="adjustPageControls" />
                                            </dx:ASPxPanel>
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                            </Items>
                    </dx:LayoutGroup>
                    <dx:LayoutItem ColSpan="1" ShowCaption="False" Width="100%">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server">
                                <dx:EntityServerModeDataSource ID="esmdCpy_prod" runat="server" OnSelecting="esmdCpy_prod_Selecting" ContextTypeName="ClientsDataModel" TableName="vcpy_prod" />
                                <dx:ASPxGridView ID="GridView" ClientInstanceName="gridView" runat="server"  KeyFieldName="uid_company"
                                    OnRowUpdating="GridView_RowUpdating" OnRowInserting="GridView_RowInserting" AutoGenerateColumns="False"
                                    OnCustomErrorText="GridView_CustomErrorText" KeyboardSupport="true" EnablePagingGestures="False" Width="100%" OnCustomButtonCallback="GridView_CustomButtonCallback">

                                    <SettingsResizing ColumnResizeMode="Control" />
                                    <SettingsBehavior AllowFocusedRow="true" AllowSelectByRowClick="true" AllowEllipsisInText="true" AllowDragDrop="false"/>
                                    <SettingsEditing Mode="Batch" UseFormLayout="false" NewItemRowPosition="Bottom">
                                        <BatchEditSettings EditMode="Row" StartEditAction="DblClick" KeepChangesOnCallbacks="True" />
                                    </SettingsEditing>   
                                    <Settings VerticalScrollBarMode="auto" VerticalScrollableHeight="250" HorizontalScrollBarMode="Auto" ShowHeaderFilterButton="true"/>
                                    <SettingsPager PageSize="100" EnableAdaptivity="true">
                                        <PageSizeItemSettings Visible="true"></PageSizeItemSettings>
                                    </SettingsPager>
                                    <SettingsCookies StorePaging="False" />
                                    <SettingsExport EnableClientSideExportAPI="true" ExportSelectedRowsOnly="true" />
                                    <Styles>
                                        <Cell Wrap="false" />
                                        <PagerBottomPanel CssClass="pager" />
                                        <FocusedRow CssClass="focused" />
                                    </Styles>
                                    <Paddings PaddingTop="0px" />

                                    <Columns>
                                        <dx:GridViewDataTextColumn FieldName="uid_company" ShowInCustomizationForm="true" Visible="false" VisibleIndex="1">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="company" Caption="Compañia" ShowInCustomizationForm="true" Visible="true" VisibleIndex="2">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="uid_prodpol" ShowInCustomizationForm="true" Visible="false" VisibleIndex="3">
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="prodpol" Caption="Producto" ShowInCustomizationForm="true" Visible="true" VisibleIndex="4">
                                        </dx:GridViewDataTextColumn>
                                    </Columns>
                                    <SettingsPopup>
                                        <FilterControl AutoUpdatePosition="False"></FilterControl>
                                    </SettingsPopup>
                                </dx:ASPxGridView>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                </Items>
            </dx:ASPxFormLayout>
        </dx:PanelContent>
    </PanelCollection>
</dx:ASPxRoundPanel>