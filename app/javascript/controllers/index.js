import { application } from "./application"
import EstimateItemsController from "./estimate_items_controller"
import DismissibleController from "./dismissible_controller"
import StarRatingController from "./star_rating_controller"

application.register("estimate-items", EstimateItemsController)
application.register("dismissible", DismissibleController)
application.register("star-rating", StarRatingController)
