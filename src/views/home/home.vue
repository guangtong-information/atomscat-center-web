<style lang="less">
@import "./home.less";
@import "../../styles/common.less";
</style>

<template>
    <div>
        <div>
            <Row :gutter="10">
                <Col :md="24" :lg="8">
                <Row class-name="home-page-row1" :gutter="10">
                    <Col :md="12" :lg="24" :style="{marginBottom: '10px'}">
                    <Card>
                        <Row type="flex" class="user-infor">
                            <Col span="8">
                            <Row class-name="made-child-con-middle" type="flex" align="middle">
                                <img class="avator-img" :src="avatarPath" />
                            </Row>
                            </Col>
                            <Col span="16" style="padding-left:6px;">
                            <Row class-name="made-child-con-middle" type="flex" align="middle">
                                <div>
                                    <b class="card-user-infor-name">{{ username }}</b>
                                    <p>欢迎您的使用</p>
                                </div>
                            </Row>
                            </Col>
                        </Row>
                        <div class="line-gray"></div>
                        <Row class="margin-top-8">
                            <Col span="8">
                            <p class="notwrap">本次登录地点:</p>
                            </Col>
                            <Col span="16" class="padding-left-8">{{city}}</Col>
                        </Row>
                        <Row class="margin-top-8">
                            <Col span="8">
                            <p class="notwrap">天气:</p>
                            </Col>
                            <Col span="16" class="padding-left-8">{{weather}}</Col>
                        </Row>
                    </Card>
                    </Col>
                </Row>
                </Col>
                <Col :md="24" :lg="16">
                    <Row :gutter="5">
                        <Col :xs="24" :sm="12" :md="6" :style="{marginBottom: '10px'}">
                        <infor-card id-name="user_created_count" :end-val="count.createUser" iconType="md-person-add" color="#2d8cf0" intro-text="今日新增用户"></infor-card>
                        </Col>
                        <Col :xs="24" :sm="12" :md="6" :style="{marginBottom: '10px'}">
                        <infor-card id-name="visit_count" :end-val="count.visit" iconType="ios-eye" color="#64d572" :iconSize="50" intro-text="今日浏览量"></infor-card>
                        </Col>
                        <Col :xs="24" :sm="12" :md="6" :style="{marginBottom: '10px'}">
                        <infor-card id-name="collection_count" :end-val="count.collection" iconType="md-cloud-upload" color="#ffd572" intro-text="今日数据采集量"></infor-card>
                        </Col>
                        <Col :xs="24" :sm="12" :md="6" :style="{marginBottom: '10px'}">
                        <infor-card id-name="transfer_count" :end-val="count.transfer" iconType="md-shuffle" color="#f25e43" intro-text="今日服务调用量"></infor-card>
                        </Col>
                    </Row>
                </Col>
            </Row>
            <Row :gutter="10">
                <Col :md="24" :lg="8" :style="{marginBottom: '10px'}">
                <Card>
                    <p slot="title" class="card-title">
                        <Icon type="md-map"></Icon>
                        每日来访量统计
                    </p>
                    <div class="data-source-row">
                        <visite-volume></visite-volume>
                    </div>
                </Card>
                </Col>
                <Col :md="24" :lg="16" :style="{marginBottom: '10px'}">
                    <Card :padding="0">
                        <p slot="title" class="card-title">
                            <Icon type="md-locate"></Icon>
                            今日服务调用地理分布
                        </p>
                        <div class="map-con">
                            <Col span="10">
                            <map-data-table :cityData="cityData" height="281" :style-obj="{margin: '12px 0 0 11px'}"></map-data-table>
                            </Col>
                            <Col span="14" class="map-incon">
                            <Row type="flex" justify="center" align="middle">
                                <home-map :city-data="cityData"></home-map>
                            </Row>
                            </Col>
                        </div>
                    </Card>
                </col>
            </Row>
        </div>
    </div>
</template>

<script>
    import {ipInfo} from "@/api/index";
    import cityData from "./map-data/get-city-value.js";
    import homeMap from "./components/map.vue";
    import visiteVolume from "./components/visiteVolume.vue";
    import userFlow from "./components/userFlow.vue";
    import countUp from "./components/countUp.vue";
    import inforCard from "./components/inforCard.vue";
    import mapDataTable from "./components/mapDataTable.vue";
    import show from "./show.vue";
    import Cookies from "js-cookie";
    import "gitalk/dist/gitalk.css";
    import Gitalk from "gitalk";

    export default {
  name: "home",
  components: {
    homeMap,
    visiteVolume,
    userFlow,
    countUp,
    inforCard,
    mapDataTable,
    show
  },
  data() {
    return {
      count: {
        createUser: 496,
        visit: 3264,
        collection: 24389305,
        transfer: 39503498
      },
      cityData: cityData,
      newToDoItemValue: "",
      city: "",
      weather: "",
      username: ""
    };
  },
  computed: {
    avatarPath() {
      return localStorage.avatorImgPath;
    }
  },
  methods: {
    init() {
      let userInfo = JSON.parse(Cookies.get("userInfo"));
      this.username = userInfo.username;
      ipInfo().then(res => {
        if (res.success) {
          if(!res.result){
              return
          }
          let ipInfo = JSON.parse(res.result);
          if (ipInfo.retCode == "200") {
            let info = ipInfo.result[0];
            let weather =
              info.weather +
              " " +
              info.temperature +
              " 污染指数: " +
              info.pollutionIndex;
            this.city = info.city;
            this.weather = weather;
          } else {
            this.city = "未知";
            this.weather = "未知";
          }
        }
      });
    }
  },
  mounted() {
    this.init();
  }
};
</script>
