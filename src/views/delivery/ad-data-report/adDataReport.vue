<style lang="less">
    @import "./adDataReport.less";
</style>
<template>
    <div>
        adDataReport
        <input v-model="params.customerShortName">
        <button @click="getList">获取数据</button>
        <button @click="add">添加数据</button>
        <Table :columns="columns1" :data="data1"></Table>
        <Page :total="total"
              :page-size="params.pageSize"
              :current="params.pageNumber"
              @on-change="change"
              @on-page-size-change="changeSize"
              :page-size-opts="size"
              show-sizer
        />
        <Modal
                v-model="modal5"
                title="Custom width"
                width="500">
            <div>
                <Form ref="reqabc" :model="req" :label-width="80" :rules="reqValidate">
                    <FormItem label="公司全称" prop="customerName">
                        <input v-model="req.customerName" placeholder="公司全称">
                    </FormItem>
                    <FormItem label="公司简称" prop="customerShortName">
                        <input v-model="req.customerShortName" placeholder="公司简称">
                    </FormItem>
                </Form>
            </div>
            <div slot="footer">
                <Button type="text" @click="modal5 = false">取消</Button>
                <Button type="primary" :loading="submitLoading" @click="addSubmit">提交</Button>
            </div>
        </Modal>
    </div>
</template>

<script>
    import {uploadFileLocal, getAccountChannel, addAccountChannel} from "@/api/index";
    import { validateMobile } from "@/libs/validate";
    export default {
        name: "adDataReport",
        data() {
            return {
                accessToken: {},
                submitLoading: false,
                req:{
                    customerName:"",
                    customerShortName:"",
                    pid: "0"
                },
                reqValidate: {
                    customerName: [
                        { required: true, message: "公司全称不能为空", trigger: "blur" }
                    ],
                    customerShortName: [
                        { required: true, message: "公司简称不能为空", trigger: "blur" }
                        // { validator: validateMobile, trigger: "blur" }
                    ],
                },
                uploadFileUrl: uploadFileLocal,
                params: {
                    customerShortName: "",
                    type: 1,
                    pageNumber: 1,
                    pageSize: 5,
                    startDate: "",
                    endDate: "",
                    pid: 0,
                    sort: 'createTime',
                    order: 'desc'
                },
                total: 0,
                columns1:[
                    {
                        title: '公司全称',
                        key: 'customerName'
                    },
                    {
                        title: '公司简称',
                        key: 'customerShortName'
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
                                                this.$refs['reqabc'].resetFields();
                                                let str = JSON.stringify(params.row);
                                                let data = JSON.parse(str);
                                                this.req = data;
                                                this.modal5 = true;
                                                // this.accountEdit(params.row);
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
                                                alert(params.row.id)
                                                // this.removeAccountModal(params.row);
                                            }
                                        }
                                    },
                                    "删除"
                                )
                            ]);
                        }
                    }],
                data1: [],
                size: [5,10,20,50,100],
                modal5: false
            }
        },
        methods:{
            add(){
                this.$refs['reqabc'].resetFields();
                this.modal5 = true;
            },
            addSubmit(){
                this.$refs['reqabc'].validate(valid => {
                    if(valid){
                        addAccountChannel(this.req).then(res => {
                            this.modal5 = false;
                            this.$refs['reqabc'].resetFields();
                            this.getList();
                        });
                    }
                });
            },
            getList(){
                getAccountChannel(this.params).then(res => {
                    this.data1 = res.result['content'];
                    this.total = res.result.totalElements;
                })
            },
            change(v){
                this.params.pageNumber = v;
                this.getList();
            },
            changeSize(v){
                this.params.pageNumber = 1;
                this.params.pageSize = v;
                this.getList();
            },
            init() {
                this.accessToken = {
                    accessToken: this.getStore("accessToken")
                };
            }
        },
        created() {
            this.init();
        }
    }
</script>