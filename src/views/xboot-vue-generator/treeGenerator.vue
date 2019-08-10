<template>
  <div class="sorry">
    <img src="@/assets/sorry.png">
    <span class="text">程序员，正在开发中...</span>

  </div>
</template>

<script>
export default {
};
</script>
<style lang="less">
  .sorry{
    height: 500px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    .text{
      font-size: 20px;
      margin: 20px 0;
    }
  }
</style>