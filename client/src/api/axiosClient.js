import axios from 'axios'
import queryString from 'query-string'
// import { REACT_APP_BACKEND_IP } from '../config';

// const baseUrl = REACT_APP_BACKEND_IP+'/api/v1/'
const getToken = () => localStorage.getItem('token')

// console.log(baseUrl)
const baseUrl = null
const axiosClient = axios.create({
  baseURL: baseUrl,
  paramsSerializer: params => queryString.stringify({ params })
})

axiosClient.interceptors.request.use(async config => {
  return {
    ...config,
    headers: {
      'Content-Type': 'application/json',
      'authorization': `Bearer ${getToken()}`
    }
  }
})

axiosClient.interceptors.response.use(response => {
  if (response && response.data) return response.data
  return response
}, err => {
  if (!err.response) {
    return alert(err)
  }
  throw err.response
})

export default axiosClient