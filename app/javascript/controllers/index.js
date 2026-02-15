import { application } from "./application"
import EstimateItemsController from "./estimate_items_controller"
import DismissibleController from "./dismissible_controller"
import StarRatingController from "./star_rating_controller"
import PhotoUploadController from "./photo_upload_controller"
import InsuranceFormController from "./insurance_form_controller"
import MobileMenuController from "./mobile_menu_controller"
import FormValidationController from "./form_validation_controller"
import ToastController from "./toast_controller"
import ToggleController from "./toggle_controller"

application.register("estimate-items", EstimateItemsController)
application.register("dismissible", DismissibleController)
application.register("star-rating", StarRatingController)
application.register("photo-upload", PhotoUploadController)
application.register("insurance-form", InsuranceFormController)
application.register("mobile-menu", MobileMenuController)
application.register("form-validation", FormValidationController)
application.register("toast", ToastController)
application.register("toggle", ToggleController)
