<style lang="less">
    @import "./accountChannel.less";
</style>
<template>
    <div class="accountChannel">
<!--   客户列表        -->
        <Row>
            <Col>
                <Card>
                    <Row>
                        <Form ref="searchForm" :model="searchForm" inline :label-width="80" class="search-form">
                            <FormItem label="客户简称" prop="customerShortName">
                                <Input v-model="searchForm.customerShortName" style="width: 250px"/>
                            </FormItem>
                            <Form-item style="margin-left:-35px;" class="br">
                                <Button @click="handleSearch" type="primary" icon="ios-search">搜索</Button>
                                <Button @click="handleReset">重置</Button>
                            </Form-item>
                        </Form>
                    </Row>
                    <Row class="operation">
                        <Button @click="add" type="primary" icon="md-add">添加</Button>
                        <Button @click="delAll" icon="md-trash">批量删除</Button>
                    </Row>
                    <Row>
                        <Table :loading="loading" border :columns="columns" :data="data" ref="table"
                               sortable="custom" @on-sort-change="changeSort"
                               @on-selection-change="changeSelect"></Table>
                    </Row>
                    <Row type="flex" justify="end" class="page">
                        <Page :current="searchForm.pageNumber" :total="total"
                              :page-size="searchForm.pageSize" @on-change="changePage"
                              @on-page-size-change="changePageSize" :page-size-opts="[10,20,50]"
                              size="small" show-total show-elevator show-sizer></Page>
                    </Row>
                </Card>
            </Col>
        </Row>
<!--    添加客户弹框    -->
        <Modal
                :title="modalTitle"
                v-model="platformModalVisible"
                :mask-closable="false"
                :width="500"
                :styles="{top: '30px'}"
        >
            <Form ref="platformForm" :model="platformForm" :label-width="80" :rules="platformFormValidate">
                <FormItem label="客户全称" prop="customerName">
                    <Input v-model="platformForm.customerName" autocomplete="off" />
                </FormItem>
                <FormItem label="客户简称" prop="customerShortName">
                    <Input v-model="platformForm.customerShortName" autocomplete="off" />
                </FormItem>
            </Form>
            <div slot="footer">
                <Button type="text" @click="platformModalVisible = false">取消</Button>
                <Button type="primary" :loading="submitLoading" @click="submitForm">提交</Button>
            </div>
        </Modal>
<!--   客户账号列表     -->
        <Modal
                :title="accountModalTitle"
                v-model="accountModalVisible"
                :mask-closable="false"
                :width="1000"
                :styles="{top: '30px'}"
        >
            <Row>
                    <Card>
                        <Row>
                            <Form ref="searchForm" :model="searchForm" inline :label-width="80" class="search-form">
                                <FormItem label="数据平台" prop="deliveryPlatform">
                                    <Select v-model="searchForm.deliveryPlatform" placeholder="请选择">
                                        <Option value="">全部</Option>
                                        <Option v-for="(item, i) in deliveryPlatform" :key="i" :value="item.value">{{item.title}}</Option>
                                    </Select>
                                </FormItem>
                                <Form-item style="margin-left:-35px;" class="br">
                                    <Button @click="AccountHandleSearch" type="primary" icon="ios-search">搜索</Button>
                                    <Button @click="AccountHandleReset">重置</Button>
                                </Form-item>
                            </Form>
                        </Row>
                        <Row class="operation">
                            <Button @click="addAccountModal" type="primary" icon="md-add">添加</Button>
                            <Button @click="delAll" icon="md-trash">批量删除</Button>
                        </Row>
                        <br/>
                        <Row>
                            <Table :loading="loading" border :columns="columnsAccount" :data="accountData" ref="accountTable"
                                   sortable="custom" @on-sort-change="accountChangeSort"
                                   @on-selection-change="accountChangeSelect"></Table>
                        </Row>
                        <Row type="flex" justify="end" class="page">
                            <Page :current="accountSearchForm.pageNumber" :total="accountTotal"
                                  :page-size="accountSearchForm.pageSize" @on-change="accountChangePage"
                                  @on-page-size-change="accountChangePageSize" :page-size-opts="[10,20,50]"
                                  size="small" show-total show-elevator show-sizer></Page>
                        </Row>
                    </Card>
            </Row>
            <div slot="footer"></div>
        </Modal>
<!--     添加客户账号   -->
        <Modal
                :title="addAccountModalTitle"
                v-model="addAccountModalVisible"
                :mask-closable="false"
                :width="500"
                :styles="{top: '30px'}"
        >
            <Form ref="accountModal" :model="accountModal" :label-width="80" :rules="accountModalValidate">
                <FormItem label="账户id" prop="accountId">
                    <Input v-model="accountModal.accountId" autocomplete="off" />
                </FormItem>
                <FormItem label="账户全称" prop="accountName">
                    <Input v-model="accountModal.accountName" autocomplete="off" />
                </FormItem>
                <FormItem label="数据平台" prop="deliveryPlatform">
                    <Select v-model="accountModal.deliveryPlatform" placeholder="请选择">
                        <Option v-for="(item, i) in deliveryPlatform" :key="i" :value="item.value">{{item.title}}</Option>
                    </Select>
                </FormItem>
<!--                <FormItem label="广告主ID" prop="advertiserId">-->
<!--                    <Input v-model="accountModal.advertiserId" autocomplete="off" />-->
<!--                </FormItem>-->
                <FormItem label="客户号" prop="channelCustomer">
                    <Input v-model="accountModal.channelCustomer" autocomplete="off" />
                </FormItem>
                <FormItem label="渠道号" prop="channelDelivery">
                    <Input v-model="accountModal.channelDelivery" autocomplete="off" />
                </FormItem>
                <FormItem label="渠道号说明" prop="channelNumberDescription">
                    <Input v-model="accountModal.channelNumberDescription" autocomplete="off" />
                </FormItem>

            </Form>
            <div slot="footer">
                <Button type="text" @click="addAccountModalVisible = false">取消</Button>
                <Button type="primary" :loading="submitLoading" @click="accountModalSubmitForm">提交</Button>
            </div>
        </Modal>
<!--        指标管理-->
        <Modal
                :title="kpiTitle"
                v-model="kpiVisible"
                :mask-closable="false"
                :width="600"
                :styles="{top: '30px'}"
        >
            <Card>
                <Row class="operation">
                    <Button @click="addKpi" type="primary" icon="md-add">添加指标</Button>
                    <Button @click="delAllKpi" icon="md-trash">批量删除</Button>
                </Row>
                <br/>
                <Row>
                    <Input
                            v-model="searchKey"
                            suffix="ios-search"
                            @on-change="searchKpi"
                            placeholder="输入菜单名搜索"
                            clearable
                    />
                </Row>
                <br/>
                <Card>
                    <Row>
                        <Tree
                                ref="tree"
                                :data="apkiData"
                                multiple
                                show-checkbox
                                :render="renderContent"
                                :check-strictly="true"
                        ></Tree>
                    </Row>
                </Card>
            </Card>
            <div slot="footer">
                <Button type="text" @click="kpiVisible = false">取消</Button>
                <Button type="primary" :loading="submitLoading" @click="saveKpiMapper" >保存</Button>
            </div>
        </Modal>
        <!--     添加kpi数据   -->
        <Modal
                :title="addKpiTitle"
                v-model="addKpiVisible"
                :mask-closable="false"
                :width="500"
                :styles="{top: '30px'}"
        >
            <Form ref="kpiForm" :model="kpiForm" :label-width="80" :rules="kpiFormValidate">
                <FormItem label="指标名称" prop="title">
                    <Input v-model="kpiForm.title" autocomplete="off" />
                </FormItem>
                <FormItem label="数据类型" prop="type">
                    <Select v-model="kpiForm.type" placeholder="请选择">
                        <Option v-for="(item, i) in typeOfData" :key="i" :value="item.value">{{item.title}}</Option>
                    </Select>
                </FormItem>
                <FormItem label="指标描述" prop="description">
                    <Input v-model="kpiForm.description" autocomplete="off" />
                </FormItem>
            </Form>
            <div slot="footer">
                <Button type="text" @click="addKpiVisible = false">取消</Button>
                <Button type="primary" :loading="submitLoading" @click="addKpiSubmit">提交</Button>
            </div>
        </Modal>
    </div>
</template>

<script>
    import {getAccountChannel, getDictDataByType, addAccountChannel, editAccountChannel, deleteAccount, addKpi, getKpiList, saveKpi} from "@/api/index";

    export default {
        name: "accountChannel",
        data() {
            return {
                loading: true,
                submitLoading: false,
                modalType: 0,
                searchKey: "",
                searchForm: {
                    type: 1,
                    pageNumber: 1,
                    pageSize: 10,
                    startDate: "",
                    endDate: "",
                    pid: "0",
                    sort: "createTime",
                    order: "desc"
                },
                accountSearchForm: {
                    type: 1,
                    pageNumber: 1,
                    pageSize: 10,
                    startDate: "",
                    endDate: "",
                    pid: "0",
                    sort: "createTime",
                    order: "desc"
                },
                selectDeliveryPlatform: '',
                platformForm: {
                    customerShortName: '',
                    customerName: '',
                    pid: '0'
                },
                platformFormValidate: {
                    customerName: [
                        { required: true, message: "不能为空", trigger: "blur" }
                    ],
                    customerShortName: [
                        { required: true, message: "不能为空", trigger: "blur" }
                    ]
                },
                kpiForm: {
                    description: "",
                    title: "",
                    type: "",
                    sort_order: ""
                },
                kpiFormValidate: {
                    title: [
                        { required: true, message: "不能为空", trigger: "blur" }
                    ],
                    type: [
                        { required: true, message: "不能为空", trigger: "blur" }
                    ]
                },
                accountModal: {
                    accountId: "",
                    accountName: "",
                    deliveryPlatform: "",
                    advertiserId: "",
                    channelCustomer: "",
                    channelDelivery: "",
                    channelNumberDescription: ""
                },
                accountModalValidate: {
                    accountId: [
                        { required: true, message: "不能为空", trigger: "blur" }
                    ],
                    accountName: [
                        { required: true, message: "不能为空", trigger: "blur" }
                    ],
                    deliveryPlatform: [
                        { required: true, message: "不能为空", trigger: "blur" }
                    ]
                },
                platformModalVisible: false,
                accountModalVisible: false,
                modalTitle: "添加",
                accountModalTitle: "客户账户管理",
                addAccountModalTitle: "添加客户账户",
                kpiTitle: "指标管理",
                kpiVisible: false,
                addKpiTitle: "添加指标",
                addKpiVisible: false,
                addAccountModalVisible: false,
                deliveryPlatform: [],
                typeOfData: [],
                apkiData: [],
                selectList: [],
                selectCount: 0,
                selectDate: null,
                data: [],
                accountData: [],
                accountTotal: 0,
                total: 0,
                columns: [
                    {
                        type: "selection",
                        width: 60,
                        align: "center",
                        fixed: "left"
                    },
                    {
                        type: "index",
                        width: 60,
                        align: "center",
                        fixed: "left"
                    },
                    {
                        title: "客户简称",
                        key: "customerShortName",
                        sortable: true,
                    },
                    {
                        title: "客户全称",
                        key: "customerName",
                        sortable: true,
                    },
                    {
                        title: "客户账户管理",
                        key: "advertiserName",
                        sortable: true,
                        align: "center",
                        width: 180,
                        render: (h, params) => {
                            return h("div", [
                                h(
                                    "Button",
                                    {
                                        props: {
                                            type: "primary",
                                            size: "small"
                                        },
                                        style: {
                                            marginRight: "5px"
                                        },
                                        on: {
                                            click: () => {
                                                this.addAccountChannel(params.row);
                                            }
                                        }
                                    },
                                    "编辑"
                                )])}
                    },
                    {
                        title: "客户指标管理",
                        key: "advertiserId",
                        sortable: true,
                        align: "center",
                        width: 180,
                        render: (h, params) => {
                            return h("div", [
                                h(
                                    "Button",
                                    {
                                        props: {
                                            type: "primary",
                                            size: "small"
                                        },
                                        style: {
                                            marginRight: "5px"
                                        },
                                        on: {
                                            click: () => {
                                                this.kpiVisibleShow(params.row);
                                            }
                                        }
                                    },
                                    "编辑"
                                )])}
                    },
                    {
                        title: "操作",
                        key: "action",
                        width: 200,
                        align: "center",
                        fixed: "right",
                        render: (h, params) => {
                            return h("div", [
                                h(
                                    "Button",
                                    {
                                        props: {
                                            type: "primary",
                                            size: "small"
                                        },
                                        style: {
                                            marginRight: "5px"
                                        },
                                        on: {
                                            click: () => {
                                                this.edit(params.row);
                                            }
                                        }
                                    },
                                    "编辑"
                                ),
                                h(
                                    "Button",
                                    {
                                        props: {
                                            type: "error",
                                            size: "small"
                                        },
                                        on: {
                                            click: () => {
                                                this.remove(params.row);
                                            }
                                        }
                                    },
                                    "删除"
                                )
                            ]);
                        }
                    }
                ],
                columnsAccount: [
                    {
                        type: "selection",
                        width: 60,
                        align: "center",
                        fixed: "left"
                    },
                    {
                        type: "index",
                        width: 60,
                        align: "center",
                        fixed: "left"
                    },
                    {
                        title: "账户id",
                        key: "accountId",
                    },
                    {
                        title: "账户全称",
                        key: "accountName",
                    },
                    {
                        title: "数据平台",
                        key: "deliveryPlatform",
                        render: (h, params) => {
                            let title = "";
                            this.deliveryPlatform.forEach((column) => {
                                if (params.row.deliveryPlatform === column.value) {
                                    title = column.title
                                }
                            });
                            return h("div", title);
                        }
                    },
                    {
                        title: "客户号",
                        key: "channelCustomer",
                    },
                    {
                        title: "渠道号",
                        key: "channelDelivery",
                    },
                    {
                        title: "渠道号说明",
                        key: "channelNumberDescription",
                    },
                    {
                        title: "操作",
                        key: "action",
                        width: 160,
                        align: "center",
                        fixed: "right",
                        render: (h, params) => {
                            return h("div", [
                                h(
                                    "Button",
                                    {
                                        props: {
                                            type: "primary",
                                            size: "small"
                                        },
                                        style: {
                                            marginRight: "5px"
                                        },
                                        on: {
                                            click: () => {
                                                this.accountEdit(params.row);
                                            }
                                        }
                                    },
                                    "编辑"
                                ),
                                h(
                                    "Button",
                                    {
                                        props: {
                                            type: "error",
                                            size: "small"
                                        },
                                        on: {
                                            click: () => {
                                                this.removeAccountModal(params.row);
                                            }
                                        }
                                    },
                                    "删除"
                                )
                            ]);
                        }
                    }
                ]
            }
        },
        methods: {
            init() {
                getDictDataByType("delivery_platform").then(res => {
                    if (res.success) {
                        this.deliveryPlatform = res.result;
                    }
                });
                getDictDataByType("type_of_data").then(res => {
                    if (res.success) {
                        this.typeOfData = res.result;
                    }
                });

                this.getList();
                this.getKpiList();
            },
            add() {
                this.modalType = 0;
                this.modalTitle = "添加";
                this.platformForm = {
                    clientId: '',
                    clientSecret: '',
                    deliveryPlatform: '',
                    redirectUri: '',
                    scope: '',
                    pid: '0'
                };
                this.$refs.platformForm.resetFields();
                this.selectDeliveryPlatform = "";
                this.platformModalVisible = true;
            },
            addAccountModal(){
                this.modalType = 0;
                this.addAccountModalTitle = "添加客户账户";
                this.accountModal = {
                  accountId: "",
                  accountName: "",
                  deliveryPlatform: "",
                  advertiserId: "",
                  channelCustomer: "",
                  channelNumberDescription: ""
                };
                this.$refs.accountModal.resetFields();
                this.addAccountModalVisible=true;
            },
            addKpi() {
                this.addKpiVisible = true;
            },
            delAllKpi() {

            },
            searchKpi() {
                this.getKpiList();
            },
            edit(item) {
                this.modalType = 1;
                this.modalTitle = "编辑";
                this.$refs.platformForm.resetFields();
                // 转换null为""
                for (let attr in item) {
                    if (item[attr] == null) {
                        item[attr] = "";
                    }
                }
                let str = JSON.stringify(item);
                let data = JSON.parse(str);
                this.platformForm = data;
                this.selectDeliveryPlatform = this.platformForm.deliveryPlatform;
                this.platformModalVisible = true;
            },
            accountEdit(item){
                this.modalType = 1;
                this.addAccountModalTitle="修改客户账户";

                this.$refs.accountModal.resetFields();
                // 转换null为""
                for (let attr in item) {
                    if (item[attr] == null) {
                        item[attr] = "";
                    }
                }
                let str = JSON.stringify(item);
                let data = JSON.parse(str);
                this.accountModal = data;
                this.addAccountModalVisible=true;
            },
            submitForm() {
                this.$refs.platformForm.validate(valid => {
                    if (valid) {
                        if (this.modalType == 0) {
                            addAccountChannel(this.platformForm).then(res => {
                                this.submitLoading = false;
                                if (res.success) {
                                    this.$Message.success("操作成功");

                                    this.getList();
                                    this.platformModalVisible = false;
                                }
                            });
                        } else {
                            editAccountChannel(this.platformForm).then(res => {
                                this.submitLoading = false;
                                if (res.success) {
                                    this.$Message.success("操作成功");
                                    this.getList();
                                    this.platformModalVisible = false;
                                }
                            });
                        }
                    }
                })
            },
            accountModalSubmitForm() {
                this.$refs.accountModal.validate(valid => {
                    if (valid) {
                        if (this.modalType == 0) {
                            this.accountModal.pid = this.searchForm.pid;
                            addAccountChannel(this.accountModal).then(res => {
                                this.submitLoading = false;
                                if (res.success) {
                                    this.$Message.success("操作成功");
                                    this.getAccountDataList();
                                    this.addAccountModalVisible = false;
                                }
                            });
                        } else {
                            editAccountChannel(this.accountModal).then(res => {
                                this.submitLoading = false;
                                if (res.success) {
                                    this.$Message.success("操作成功");
                                    this.getList();
                                    this.addAccountModalVisible = false;
                                }
                            });
                        }
                    }
                })
            },
            addKpiSubmit(){
                this.$refs.kpiForm.validate(valid => {
                    if (valid) {
                        addKpi(this.kpiForm).then(res => {
                            this.submitLoading = false;
                            if (res.success) {
                                this.$Message.success("操作成功");
                                this.getKpiList();
                                this.addKpiVisible = false;
                            }
                        });
                    }
                })
            },
            saveKpiMapper() {
                let permIds = "";
                let selectedNodes = this.$refs.tree.getCheckedNodes();
                selectedNodes.forEach(function(e) {
                    if(e.id != "0"){
                        permIds += e.id + ",";
                    }
                });
                saveKpi({
                    id: this.searchForm.pid,
                    kpiIds: permIds
                }).then(res => {
                    this.submitLoading = false;
                    if (res.success) {
                        this.$Message.success("操作成功");
                        this.getList();
                        this.kpiVisible = false;
                    }
                });
            },
            renderContent(h, { root, node, data }) {
                return h(
                    "span",
                    {
                        style: {
                            display: "inline-block",
                            cursor: "pointer"
                        },
                        on: {
                            click: () => {
                                data.checked = !data.checked;
                            }
                        }
                    },
                    [
                        h("span", [
                            h("span", { class: "ivu-tree-title" }, data.title)
                        ])
                    ]
                );
            },
            remove(v) {
                this.$Modal.confirm({
                    title: "确认删除",
                    content: "您确认要删除该数据?",
                    onOk: () => {
                        this.$store.commit("setLoading", true);
                        deleteAccount(v.id).then(res => {
                            this.$store.commit("setLoading", false);
                            if (res.success) {
                                this.$Message.success("删除成功");
                                this.getList();
                            }
                        });
                    }
                });
            },
            removeAccountModal(v) {
                this.$Modal.confirm({
                    title: "确认删除",
                    content: "您确认要删除该数据?",
                    onOk: () => {
                        this.$store.commit("setLoading", true);
                        deleteAccount(v.id).then(res => {
                            this.$store.commit("setLoading", false);
                            if (res.success) {
                                this.$Message.success("删除成功");
                                this.getAccountDataList();
                            }
                        });
                    }
                });
            },
            delAll() {
                if (this.selectCount <= 0) {
                    this.$Message.warning("您还未选择要删除的数据");
                    return;
                }
                this.$Modal.confirm({
                    title: "确认删除",
                    content: "您确认要删除所选的 " + this.selectCount + " 条数据?",
                    onOk: () => {
                        let ids = "";
                        this.selectList.forEach(function(e) {
                            ids += e.id + ",";
                        });
                        ids = ids.substring(0, ids.length - 1);
                        this.$store.commit("setLoading", true);
                        deleteAccount(ids).then(res => {
                            this.$store.commit("setLoading", false);
                            if (res.success) {
                                this.$Message.success("删除成功");
                                this.clearSelectAll();
                                this.getList();
                            }
                        });
                    }
                });
            },
            addAccountChannel(row){
                this.searchForm.pid = row['id'];
                getAccountChannel(this.searchForm).then(res => {
                    this.loading = false;
                    if (res.success) {
                        this.accountModalVisible = true;
                        this.accountData = res.result.content;
                        this.accountTotal = res.result.totalElements;
                    }
                });
            },
            kpiVisibleShow(row){
                this.$refs.tree.getCheckedNodes().forEach(function (item) {
                    item.checked = false;
                });
                let kpiIds = row['kpiIds'];
                let list = [], list1 = [], list2 = [];

                this.apkiData.forEach(function (item) {
                    let isTrue = false;
                    if(kpiIds !== null && kpiIds !== "" && kpiIds.length !== 0){
                        kpiIds.split(',').forEach(function (i) {
                            if(item.id === i) {
                                console.info(i)
                                item.checked = true;
                                isTrue = true;
                            }
                        });
                    }
                    if(isTrue){
                        list1.push(item)
                    } else {
                        list2.push(item)
                    }
                });
                list = list1.concat(list2);
                this.apkiData = list;
                this.searchForm.pid = row['id'];
                this.kpiVisible = true;
            },
            handleSearch() {
                this.searchForm.pageNumber = 1;
                this.searchForm.pageSize = 10;
                this.searchForm.pid = '0';
                this.getList();
            },
            handleReset() {
                this.selectDate = null;
                this.searchForm.startDate = "";
                this.searchForm.endDate = "";
                this.searchForm.pid = '0';
                this.getList();
            },
            AccountHandleSearch() {
                this.accountSearchForm.pageNumber = 1;
                this.accountSearchForm.pageSize = 10;
                this.getAccountDataList();
            },
            AccountHandleReset() {
                this.accountData = null;
                this.accountSearchForm.startDate = "";
                this.accountSearchForm.endDate = "";
                this.getAccountDataList();
            },
            selectDateRange(v) {
                if (v) {
                    this.searchForm.startDate = v[0];
                    this.searchForm.endDate = v[1];
                }
            },
            getList() {
                this.searchForm.pid='0';
                this.loading = true;
                getAccountChannel(this.searchForm).then(res => {
                    this.loading = false;
                    if (res.success) {
                        this.data = res.result.content;
                        this.total = res.result.totalElements;
                    }
                });
            },
            getKpiList() {
                let form = {
                    title: this.searchKey
                };
                getKpiList(form).then(res => {
                    if (res.success) {
                        let list = res.result;
                        list.forEach(item=>{
                            item["checked"]=false;
                        });
                        this.apkiData = list;
                    }
                });
            },
            getAccountDataList(){
                this.loading = true;
                this.accountSearchForm.pid = this.searchForm.pid;
                getAccountChannel(this.accountSearchForm).then(res => {
                    this.loading = false;
                    if (res.success) {
                        this.accountData = res.result.content;
                        this.accountTotal = res.result.totalElements;
                    }
                });
            },
            changeSort(e) {
                this.searchForm.sort = e.key;
                this.searchForm.order = e.order;
                if (e.order == "normal") {
                    this.searchForm.order = "";
                }
                this.getList();
            },
            changeSelect(e) {
                this.selectList = e;
                this.selectCount = e.length;
            },
            changePage(v) {
                this.searchForm.pageNumber = v;
                this.getList();
                this.clearSelectAll();
            },
            changePageSize(v) {
                this.searchForm.pageSize = v;
                this.getList();
            },
            clearSelectAll() {
                this.$refs.table.selectAll(false);
            }
            ,
            accountChangeSort(e) {
                this.accountSearchForm.sort = e.key;
                this.accountSearchForm.order = e.order;
                if (e.order == "normal") {
                    this.accountSearchForm.order = "";
                }
                this.getAccountDataList();
            },
            accountChangeSelect(e) {
                this.selectList = e;
                this.selectCount = e.length;
            },
            accountChangePage(v) {
                this.accountSearchForm.pageNumber = v;
                this.getAccountDataList();
                this.clearSelectAll();
            },
            accountChangePageSize(v) {
                this.accountSearchForm.pageSize = v;
                this.getAccountDataList();
            },
            accountClearSelectAll() {
                this.$refs.accountTable.selectAll(false);
            }
        },
        mounted() {
            this.init();
        },
        watch: {
            selectDeliveryPlatform: function (val) {
                this.deliveryPlatform.forEach((column)=>{
                    if (val === column.value) {
                        this.platformForm.deliveryPlatform=this.selectDeliveryPlatform
                        this.platformForm.redirectUri = column.description
                    }
                })
            }
        },
    }
</script>