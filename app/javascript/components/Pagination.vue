<template>
  <div class="text-xs-center" style="margin: 20px 0 40px 0;">
    <v-pagination
      v-model="currentPagination"
      :length="totalPages"
      @input="setBookmark"
    ></v-pagination>
  </div>
</template>

<script>
export default {
  name: 'Pagination',
  props: ['currentPage', 'totalPages'],
  computed: {
    currentPagination: {
      get() {
        return this.currentPage
      },
      set(newPage) {
        this.$emit('change-page', newPage)
      }
    }
  },
  methods: {
    setBookmark() {
      this.$emit('pagination')
    }
  }
}
</script>