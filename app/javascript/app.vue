<template>
  <v-app id="app">
    <Loading v-show="isLoading"></Loading>
    <v-container style="height: 1000px; max-width: 2400px; padding: 0 20px;">
      <v-layout>
        <v-flex xs2 style="justify-content: center; padding: 20px 5px 0 5px">
          <h3>フリーワードで探す</h3>
          <v-text-field v-model="searchWord" @keyup="abstruct" label="Input Keyword" style='margin-top:4px'></v-text-field>
          <br>
          <h3>カテゴリーごとに絞る</h3>
          <v-select
            v-model='category'
            :items="categories"
            label="Category"
            v-on:change="abstruct">
          </v-select>
        </v-flex>

        <v-flex xs8>
          <div style="width: 100%; margin: 5px 0 20px 0; display: flex; justify-content: center;">
            <h1>Bookmark 一覧</h1>
          </div>
        
          <BookmarkList :bookmarkList="bookmarkList" :itemsPerPage="itemsPerPage" @put-click="togglePutModal" @delete-click="toggleDeleteModal"></BookmarkList>

          <div class="text-xs-center" style="margin: 20px 0 40px 0;">
            <v-pagination
              v-model="currentPage"
              :length="totalPages"
              @input="setBookmark"
            ></v-pagination>
          </div>
        </v-flex>

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
      </v-layout>

        <AddDialog :dialogPostFlag="dialogPostFlag" :categoriesForEdit="categoriesForEdit" @post-cancel-click="togglePostModal" @post-click="postBookmark"></AddDialog>

        <v-dialog v-model="dialogPutFlag" width="500px" persistent>
          <v-card>
            <v-card-title class="headline orange darken-4 white--text" primary-title>
              Edit Form
            </v-card-title>

            <v-text-field v-model="putTitle" :counter="50" label="Title" required style='margin:20px;'></v-text-field> 
            <v-text-field v-model="putUrl" label="URL" required style='margin:20px;'></v-text-field> 
            <v-text-field v-model="putCategory" :counter="50" label="Category" required style='margin:20px;'></v-text-field> 
            <v-select v-model='putCategory' :items="categoriesForEdit" label="Category [select]" style='margin:20px;'></v-select>

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

        <DeleteDialog :dialogDeleteFlag="dialogDeleteFlag" @delete-click="deleteBookmark" @delete-cancel-click="deleteCancel"></DeleteDialog>

    </v-container>
  </v-app> 
</template>

<script>
import Loading from './components/Loading'
import BookmarkList from './components/BookmarkList'
import AddDialog from './components/AddDialog'
import DeleteDialog from './components/DeleteDialog'
import axios from 'axios';
axios.defaults.headers.common = {
    'X-Requested-With': 'XMLHttpRequest',
    'X-CSRF-TOKEN' : document.querySelector('meta[name="csrf-token"]').getAttribute('content')
};
export default {
  data: function () {
    return {
      isLoading: true,
      bookmarkList: ['',''],
      allData: ['',''],
      categories: ['All'],
      categoriesForEdit: [],
      category: 'ALL',
      bookmarks: "bookmarks",
      dialogPostFlag: false,
      postTitle: "",
      postUrl: "",
      postCategory: "",
      dialogPutFlag: false,
      putTitle: '',
      putUrl: '',
      putCategory: '',
      dialogDeleteFlag: false,
      searchWord: '',
      currentPage: 1,
      itemsPerPage: 3,
      totalPages: null,
    }
  },
  mounted () {
    axios.get("/api/bookmarks")
    .then(response => {
        this.allData = response.data;
        this.isLoading = false;
      }
    );
    this.setBookmark();
  },
  components: {
    Loading,
    BookmarkList,
    AddDialog,
    DeleteDialog,
  },
  methods: {
    setBookmark: function () {
      const url = `/api/bookmarks?page=${this.currentPage}?per=${this.itemsPerPage}`;
      axios.get(url)
      .then(response => {
        this.allData = response.data.bookmarks
        this.bookmarkList = this.allData
        this.totalPages = response.data.total_pages
        this.listCategories();
        this.abstruct();
        }
      );
    },
    listCategories: function() {
      this.categories = []
      this.categoriesForEdit = []
      this.categories.push('ALL')
      var i = 0;
      for (i=0; i<this.allData.length; i++) {
        if (this.categories.indexOf(this.allData[i].category) == -1) {
          this.categories.push(this.allData[i].category)
          this.categoriesForEdit.push(this.allData[i].category)
        }
      }
    },
    togglePostModal: function() {
      this.dialogPostFlag = !this.dialogPostFlag
    },
    postBookmark: function(...args) {
      this.postTitle = args[0]
      this.postUrl = args[1]
      this.postCategory = args[2]
      axios.post('/api/bookmarks', {title:this.postTitle, url:this.postUrl, category:this.postCategory})
        .then(response => {
          this.setBookmark();
          this.postTitle = ''
          this.postUrl = ''
          this.postCategory = ''
        }
      );
      this.dialogPostFlag = !this.dialogPostFlag
    },
    togglePutModal: function(id) {
      this.id = id
      axios.get(`/api/bookmarks/${this.id}.json`)
        .then(response => {
          this.putTitle = response.data.title
          this.putUrl = response.data.url
          this.putCategory = response.data.category
        }
      );
      this.dialogPutFlag = !this.dialogPutFlag
    },
    putBookmark: function() {
      axios.put(`/api/bookmarks/${this.id}`, {title:this.putTitle, url:this.putUrl, category:this.putCategory})
        .then(response => {
          this.setBookmark();
        }
      );
      this.dialogPutFlag = !this.dialogPutFlag
    },
    editCancel: function() {
      this.dialogPutFlag = !this.dialogPutFlag
    },
    deleteBookmark: function() {
      axios.delete(`/api/bookmarks/${this.id}`)
        .then(response => {
          this.setBookmark();
        }
      );
      this.dialogDeleteFlag = !this.dialogDeleteFlag
    },
    toggleDeleteModal: function(id) {
      this.id = id
      this.dialogDeleteFlag = !this.dialogDeleteFlag
    },
    deleteCancel: function() {
      this.dialogDeleteFlag = !this.dialogDeleteFlag
    },
    abstruct: function() {
      var i = 0;
      if (this.category == 'ALL') {
        this.bookmarkList = []
        for (i=0; i<this.allData.length; i++) {
          if ((this.allData[i].title.indexOf(this.searchWord) !== -1) || (this.allData[i].category.indexOf(this.searchWord) !== -1)) {
            this.bookmarkList.push(this.allData[i])
          }
        }   
      } else if (this.category != '') { 
        this.bookmarkList = []
        for (i=0; i<this.allData.length; i++) {
          if (this.allData[i].category == this.category) {
            if ((this.allData[i].title.indexOf(this.searchWord) !== -1) || (this.allData[i].category.indexOf(this.searchWord) !== -1)) {
              this.bookmarkList.push(this.allData[i])
            }
          }
        }   
      }
    }
  }
}
</script>

<style scoped>
p {
  font-size: 20px;
  text-align: center;
}
a {
  text-decoration: none;
}
</style>
