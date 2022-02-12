<template>
  <v-flex xs2>
    <v-btn @click="togglePostModal()" style="margin: 20px 0 40px 0;">
      <span class="material-icons" style="margin-right: 4px;">add</span>Bookmarkを追加する
    </v-btn>
    <p style="margin-right: 30px">- Bookmark List -</p>
    <ul v-for="bookmark in bookmarkList" :key="bookmark.id" style="list-style: none; margin-right: 30px">
      <li style="margin-top: 10px;">
        <a v-bind:href="bookmark.url" target="_blank" rel="noopener noreferrer">{{ bookmark.title }}</a>
      </li>
      <hr>
    </ul>
  </v-flex>
</template>

<script>
export default {
  name: 'Sidebar',
  props: ['bookmarkList'],
  methods: {
    togglePostModal() {
      this.$emit('add-click')
    }
  }
}
</script>