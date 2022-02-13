<template>
  <v-layout>
    <v-flex row wrap style="justify-content: center;">
      <draggable v-model="bookmarkListComponent" style="margin: 0 25px; width: 80%; cursor: pointer;">
        <v-card v-for="bookmark in bookmarkListComponent" :key="bookmark.id" :items-per-page="itemsPerPage" style="width: 100%">
          <v-card-title primary-title style="margin-bottom: 15px; width: 100%; padding-bottom: 10px;">
            <div style="width: 100%;">
              <div class="headline mb-0" style="display: flex; justify-content: space-between; width: 100%">
                <a v-bind:href="bookmark.url" target="_blank" rel="noopener noreferrer" style="font-size: 18px;">
                  {{ bookmark.title }}
                </a>
                
                <v-tooltip right>
                  <template v-slot:activator="{ on }">
                    <v-btn light v-on="on" @click="togglePutModal(bookmark.id)" style="margin-bottom: 8px">
                      <span class="material-icons" style="margin-right: 4px;">create</span>
                    </v-btn>
                  </template>
                  <span>編集する</span>
                </v-tooltip>

              </div>
              <v-divider></v-divider>
              <div style="font-size: 16px; display: flex; justify-content: space-between; width: 100%">
                <div>#{{ bookmark.category }}</div>
                
                <v-tooltip right>
                  <template v-slot:activator="{ on }">
                    <v-btn dark v-on="on" @click="toggleDeleteModal(bookmark.id)" style="margin-top: 8px">
                      <span class="material-icons" style="margin-right: 4px;">delete</span>
                    </v-btn>
                  </template>
                  <span>削除する</span>
                </v-tooltip>

              </div>
            </div>
          </v-card-title>
        </v-card>
      </draggable>
    </v-flex>
  </v-layout>
</template>

<script>
import draggable from 'vuedraggable'

export default {
  name: 'BookmarkList',
  props: ['bookmarkList', 'itemsPerPage'],
  components: {
    draggable,
  },
  computed: {
    bookmarkListComponent: {
      get() {
        return this.bookmarkList
      },
      set(newBookmarkList) {
        this.$emit('change-bookmark-list', newBookmarkList)
      }
    }
  },
  methods: {
    togglePutModal(id) {
      this.$emit('put-click', id)
    },
    toggleDeleteModal(id) {
      this.$emit('delete-click', id)
    }
  }
}
</script>