<template>
  <v-dialog v-model="dialogPostFlag" width="500px" persistent>
    <v-card>
      <v-card-title class="headline blue-grey darken-3 white--text" primary-title>
        Create Form
      </v-card-title>

      <v-text-field v-model="postTitleDialog" :counter="50" label="Title" required style='margin:20px;'></v-text-field> 
      <v-text-field v-model="postUrlDialog" label="URL" required style='margin:20px;'></v-text-field> 
      <v-text-field v-model="postCategoryDialog" :counter="50" label="Category" required style='margin:20px;'></v-text-field> 
      <v-select v-model='postCategoryDialog' :items="categoriesForEdit" label="Category [select]" style='margin:20px;'></v-select>

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
  name: 'AddDialog',
  props: ['dialogPostFlag', 'postTitle', 'postUrl', 'postCategory', 'categoriesForEdit'],
  computed: {
    postTitleDialog: {
      get() {
        return this.postTitle
      },
      set(newTitle) {
        this.$emit('change-post-title', newTitle)
      }
    },
    postUrlDialog: {
      get() {
        return this.postUrl
      },
      set(newUrl) {
        this.$emit('change-post-url', newUrl)
      }
    },
    postCategoryDialog: {
      get() {
        return this.postCategory
      },
      set(newCategory) {
        this.$emit('change-post-category', newCategory)
      }
    }
  },
  methods: {
    togglePostModal() {
      this.$emit('post-cancel-click')
    },
    postBookmark() {
      this.$emit('post-click')
    }
  }
}
</script>