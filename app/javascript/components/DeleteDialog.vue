<template>
  <v-dialog v-model="dialogDeleteFlag" width="400" persistent>
    <v-card>
      <v-card-title class="headline blue-grey darken-3 white--text" primary-title>
        Confirm
      </v-card-title>
      <br>
      <br>
      <v-card-text>
        <p>本当に削除してもよろしいですか？</p>
      </v-card-text>

      <v-divider></v-divider>

      <v-card-actions>
        <v-btn dark @click="deleteCancel()">
          Cancel
        </v-btn>
        <v-spacer></v-spacer>
        <v-btn dark class="yellow--text" @click="deleteBookmark()">
          Delete
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  name: 'DeleteDialog',
  props: ['dialogDeleteFlag'],
  methods: {
    deleteBookmark() {
      this.$emit('delete-click')
    },
    deleteCancel() {
      this.$emit('delete-cancel-click')
    }
  }
}
</script>