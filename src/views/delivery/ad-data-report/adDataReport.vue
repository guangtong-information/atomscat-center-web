<style lang="less">
    @import "./adDataReport.less";
</style>
<template>
    <div>
        adDataReport
        <Upload
                ref="upload"
                :show-upload-list="false"
                :on-success="handleSuccess"
                :on-error="handleError"
                :format="['xls','xlsx']"
                :max-size="5120"
                :on-format-error="handleFormatError"
                :on-exceeded-size="handleMaxSize"
                :before-upload="handleBeforeUpload"
                :action="uploadFileUrl"
                :headers="accessToken"
                style="display: -webkit-inline-box;"
        >
            <Button icon="ios-cloud-upload-outline">导入客户数据</Button>
        </Upload>
    </div>
</template>

<script>
    import {uploadFileLocal} from "@/api/index";
    export default {
        name: "adDataReport",
        data() {
            return {
                accessToken: {},
                uploadFileUrl: uploadFileLocal
            }
        },
        methods:{
            init() {
                this.accessToken = {
                    accessToken: this.getStore("accessToken")
                };
            },
            handleSuccess: function () {

            },
            handleError: function () {

            },
            handleFormatError: function () {

            },
            handleMaxSize: function () {
                
            },
            handleBeforeUpload: function () {
                
            }
        },
        created() {
            this.init();
        }
    }
</script>