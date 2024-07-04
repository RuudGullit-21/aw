
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьВидимость();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимость()
	ЭтоКОРП = уатОбщегоНазначенияПовтИсп.ВариантПоставкиКОРП();
	
	ВладелецРейса = Объект.Рейс.Владелец;
	ЭтоРасписаниеМаршрута = (ТипЗнч(ВладелецРейса) = Тип("СправочникСсылка.уатМаршруты"))
		Или (Не ЗначениеЗаполнено(ВладелецРейса) И ЗначениеЗаполнено(Объект.Маршрут));
	
	Элементы.ГруппаМаршрут.Видимость = ЭтоРасписаниеМаршрута;
	Элементы.Выход.Видимость = ЭтоРасписаниеМаршрута;
	Элементы.Рейс.Видимость = ЭтоРасписаниеМаршрута;
	Элементы.УИДПункта.Видимость = ЭтоРасписаниеМаршрута;
	Элементы.FTL.Видимость = ЭтоКОРП;
	Элементы.ДнейДоОтправления.Видимость = ЭтоКОРП;
	
	Элементы.ПунктНазначения.Видимость = Не ЭтоРасписаниеМаршрута;
	Элементы.ГруппаПунктОтправления.Видимость = Не ЭтоРасписаниеМаршрута;
	Элементы.Грузоотправитель.Видимость = Не ЭтоРасписаниеМаршрута;
	Элементы.Грузополучатель.Видимость = Не ЭтоРасписаниеМаршрута;
	Элементы.ДнейВПути.Видимость = Не ЭтоРасписаниеМаршрута;
КонецПроцедуры

#КонецОбласти


