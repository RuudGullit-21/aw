
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустой() Тогда 
		Запись.Отправитель  = Пользователи.АвторизованныйПользователь();
	КонецЕсли;

	УстановитьНадписьОтправлено();
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СтатусыСообщенияМобильногоПриложения, "Идентификатор", Запись.Идентификатор);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ВидСообщенияПриИзменении(Неопределено);
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	УстановитьНадписьОтправлено();
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ВодителиКРегистрации = Новый Массив();
	ВодителиКРегистрации.Добавить(ТекущийОбъект.Отправитель);
	
	уатМобильноеПриложениеВодителяСервер.ЗарегистрироватьНеобходимостьОбновленияСообщений(ВодителиКРегистрации);
	уатМобильноеПриложениеВодителяСервер.ПроверитьВыполнитьОтправкуPUSH();
	УстановитьНадписьОтправлено();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидСообщенияПриИзменении(Элемент)
	
	Если Запись.ВидСообщения = ПредопределенноеЗначение("Перечисление.уатВидыСообщенийМобильногоПриложения.Исходящее") Тогда
		ДоступныеТипы = Новый Массив;
		ДоступныеТипы.Добавить("СправочникСсылка.Пользователи");
		ДоступныеТипы.Добавить("СправочникСсылка.уатЧаты");
		Элементы.Отправитель.ОграничениеТипа = Новый ОписаниеТипов(ДоступныеТипы);
	Иначе
		Если ТипЗнч(Запись.Отправитель) = Тип("СправочникСсылка.Пользователи") Тогда
			Элементы.Отправитель.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица, СправочникСсылка.Пользователи");
		Иначе
			Элементы.Отправитель.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьНадписьОтправлено()
	
	Элементы.ПризнакОтправки.ТекущаяСтраница = ?(Запись.Отправлено, 
		Элементы.ГруппаОтправлено,
		Элементы.ГруппаНеОтправлено);
	
КонецПроцедуры

#КонецОбласти