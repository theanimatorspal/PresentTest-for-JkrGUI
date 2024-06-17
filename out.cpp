
#pragma once
#include <concepts>
#include <cstdio>
#include <fstream>
#include <functional>
#include <iostream>
#include <map>
#include <mutex>
#include <optional>
#include <queue>
#include <span>
#include <sstream>
#include <stack>
#include <string>
#include <thread>
#include <type_traits>
#include <unordered_map>
#include <variant>
#include <vector>


#define GETTER inline auto
#define SETTER inline void

#ifdef max
#undef max
#endif

#ifdef min
#undef min
#endif

template <typename... T> using var           = std::variant<T...>;
using s                                      = std::string;
using sv                                     = std::string_view;

template <typename T> using v                = std::vector<T>;
template <typename T> using up               = std::unique_ptr<T>;
template <typename T> using sp               = std::shared_ptr<T>;
template <typename T> using opt              = std::optional<T>;
template <typename T> using optref           = std::optional<std::reference_wrapper<T>>;
template <typename T, typename U> using p    = std::pair<T, U>;
template <typename T, typename U> using umap = std::unordered_map<T, U>;
template <typename T, typename U> using map  = std::map<T, U>;
using Number                                 = double;
using Integer                                = int;
using ui                                     = uint32_t;
using si                                     = int32_t;
using sz                                     = size_t;
using sc                                     = signed char;
using uc                                     = unsigned char;

#define mu std::make_unique
#define mv std::move
#define mksh std::make_shared
#define g std::get


namespace lbirali {


using atype = opt<var<s>>;
struct Expr;
struct Visitor {
};

}
