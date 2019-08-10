<template>
  <div>
    <Row class="header">
      <img src="../../assets/logo-max.png" width="40px">
<!--      <div class="description">{{ $t('xboot') }}</div>-->
    </Row>
  </div>
</template>

<script>
export default {
  name: "header"
};
</script>

<style lang="less">
.header {
  margin-top: 10vh;
  margin-bottom: 6vh;
  text-align: center;

  .description {
    font-size: 14px;
    color: rgba(0, 0, 0, 0.45);
    margin-top: 1vh;
  }
}
</style>
