<template>
  <v-dialog v-model="dialogPutFlag" width="500px" persistent>
    <v-card>
      <v-card-title class="headline orange darken-4 white--text" primary-title>
        Edit Form
      </v-card-title>

      <v-text-field v-model="putTitleDialog" :counter="50" label="Title" required style='margin:20px;'></v-text-field> 
      <v-text-field v-model="putUrlDialog" label="URL" required style='margin:20px;'></v-text-field> 
      <v-text-field v-model="putCategoryDialog" :counter="50" label="Category" required style='margin:20px;'></v-text-field> 
      <v-select v-model='putCategoryDialog' :items="categoriesForEdit" label="Category [select]" style='margin:20px;'></v-select>

      <v-divider></v-divider>
      <v-card-actions>
        <v-btn dark @click="editCancel">
          Cancel
        </v-btn>
        <v-spacer></v-spacer>
        <v-btn @click="putBookmark">
          Update
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  name: 'EditDialog',
  props: ['dialogPutFlag', 'categoriesForEdit', 'putTitle', 'putUrl', 'putCategory'],
  computed: {
    putTitleDialog: {
      get() {
        return this.putTitle
      },
      set(newTitle) {
        this.$emit('change-title', newTitle)
      }
    },
    putUrlDialog: {
      get() {
        return this.putUrl
      },
      set(newUrl) {
        this.$emit('change-url', newUrl)
      }
    },
    putCategoryDialog: {
      get() {
        return this.putCategory
      },
      set(newCategory) {
        this.$emit('change-category', newCategory)
      }
    }
  },
  methods: {
    putBookmark() {
      this.$emit('edit-click')
    },
    editCancel() {
      this.$emit('edit-cancel-click')
    }
  }
}
</script>