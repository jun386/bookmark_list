<template>
  <v-flex xs2 style="justify-content: center; padding: 20px 5px 0 5px">
    <h3>フリーワードで探す</h3>
    <v-text-field v-model="searchWordComponent" @keyup="abstruct" label="Input Keyword" style='margin-top:4px'></v-text-field>
    <br>
    <h3>カテゴリーごとに絞る</h3>
    <v-select
      v-model='categoryComponent'
      :items="categories"
      label="Category"
      v-on:change="abstruct">
    </v-select>
  </v-flex>
</template>

<script>
export default {
  name: 'Search',
  props: ['searchWord', 'category', 'categories'],
  computed: {
    searchWordComponent: {
      get() {
        return this.searchWord
      },
      set(newSearchWord) {
        this.$emit('change-search-word', newSearchWord)
      }
    },
    categoryComponent: {
      get() {
        return this.category
      },
      set(newSearchCategory) {
        this.$emit('change-search-category', newSearchCategory)
      }
    }
  },
  methods: {
    abstruct() {
      this.$emit('search')
    }
  }
}
</script>