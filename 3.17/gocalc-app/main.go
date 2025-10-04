package main

import (
    "fmt"
    "net/http"
    "strconv"
)

func main() {
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, "Простое веб-приложение калькулятор!\n")
        fmt.Fprintf(w, "Используйте /add?a=5&b=3 для сложения.\n")
    })

    http.HandleFunc("/add", func(w http.ResponseWriter, r *http.Request) {
        a, errA := strconv.Atoi(r.URL.Query().Get("a"))
        b, errB := strconv.Atoi(r.URL.Query().Get("b"))

        if errA != nil || errB != nil {
            http.Error(w, "Пожалуйста, предоставьте два корректных числа.", http.StatusBadRequest)
            return
        }
        fmt.Fprintf(w, "Результат: %d", a+b)
    })

    fmt.Println("Сервер запущен на порту 8080")
    http.ListenAndServe(":8080", nil)
}