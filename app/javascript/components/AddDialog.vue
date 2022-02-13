<template>
  <v-dialog v-model="dialogPostFlag" width="500px" persistent>
    <v-card>
      <v-card-title class="headline blue-grey darken-3 white--text" primary-title>
        Create Form
      </v-card-title>

      <v-text-field v-model="postTitle" :counter="50" label="Title" required style='margin:20px;'></v-text-field> 
      <v-text-field v-model="postUrl" label="URL" required style='margin:20px;'></v-text-field> 
      <v-text-field v-model="postCategory" :counter="50" label="Category" required style='margin:20px;'></v-text-field> 
      <v-select v-model='postCategory' :items="categoriesForEdit" label="Category [select]" style='margin:20px;'></v-select>

      <v-divider></v-divider>
      <v-card-actions>
        <v-btn dark @click="togglePostModal">
          Cancel
        </v-btn>
        <v-spacer></v-spacer>
        <v-btn @click="postBookmark">
          Add Bookmark
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  data: function () {
    return {
      postTitle: "",
      postUrl: "",
      postCategory: "",
    }
  },
  name: 'AddDialog',
  props: ['dialogPostFlag', 'categoriesForEdit'],
  methods: {
    togglePostModal() {
      this.$emit('post-cancel-click')
    },
    postBookmark() {
      this.$emit('post-click', this.postTitle, this.postUrl, this.postCategory)
    }
  }
}
</script>