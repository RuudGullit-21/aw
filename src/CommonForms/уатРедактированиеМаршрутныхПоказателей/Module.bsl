
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Расстояние",                 Расстояние);
	Параметры.Свойство("ВремяВПути",                 ВремяВПути);
	Параметры.Свойство("ВесБрутто",                  ВесБрутто);
	Параметры.Свойство("Объем",                      Объем);
	Параметры.Свойство("КоличествоМест",             КоличествоМест);
	Параметры.Свойство("СтоимостьГруза",             СтоимостьГруза);
	Параметры.Свойство("ОтображатьСтоимость",        ОтображатьСтоимость);
	Параметры.Свойство("ВалютаТоваров",              ВалютаТоваров);
	Параметры.Свойство("ОтображатьВалюту",           ОтображатьВалюту);
	Параметры.Свойство("ВидДокумента",               ВидДокумента);
	Параметры.Свойство("FTL",                        FTL);
	Параметры.Свойство("ЗаказПеревозчику_ПоЗаказам", ЗаказПеревозчику_ПоЗаказам);
	Параметры.Свойство("Выработка1",                 Выработка1);
	Параметры.Свойство("Выработка2",                 Выработка2);
	Параметры.Свойство("ПараметрВыработки1",         ПарамВыработки1);
	Параметры.Свойство("ПараметрВыработки2",         ПарамВыработки2);
	
	Если Параметры.Свойство("ВесТары") Тогда 
		ВесТары = Параметры.ВесТары;
	Иначе 
		Элементы.ВесТары.Видимость = Ложь;
	КонецЕсли;
	
	Если ВидДокумента = "уатСтраховойСертификат_уэ" Тогда
		Элементы.ГруппаПробег.Видимость                  = Ложь;
		Элементы.ГруппаВремя.Видимость                   = Ложь;
		Элементы.ГруппаДополнительнаяВыработка.Видимость = Ложь;
	//ИначеЕсли ВидДокумента = "уатЗаказГрузоотправителя" Тогда
	//	Элементы.ВремяСтоянок.ТолькоПросмотр = Истина;
	//	Элементы.ВремяСтоянок.КнопкаВыбора = Истина;
	//	Если Параметры.Свойство("ДетализацияЗакрытия")
	//		И ДетализацияЗакрытия = Перечисления.уатДетализацияЗаказаГрузоотправителя_уэ.ПоГрузовымМестам Тогда
	//		Элементы.КоличествоМест.ТолькоПросмотр = Истина;
	//	КонецЕсли;
	ИначеЕсли ВидДокумента = "уатМаршрутныйЛист" Тогда
		Элементы.ПробегПорожний.ТолькоПросмотр = Истина;
		Элементы.ПробегПорожний.ЦветРамки = ЦветаСтиля.ЦветФонаФормы;
	КонецЕсли;
	
	Если Параметры.Свойство("ВремяСтоянок") Тогда 
		ВремяСтоянок           = Параметры.ВремяСтоянок;
		ВремяОбщее             = уатЗащищенныеФункцииСервер.СложитьВремя(ВремяВПути, ВремяСтоянок);
		ОтображатьВремяСтоянок = Истина;
	Иначе 
		ОтображатьВремяСтоянок          = Ложь;
		Элементы.ВремяОбщее.Видимость   = Ложь;
		Элементы.ВремяСтоянок.Видимость = Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("ПробегСГрузом") Тогда
		ОтображатьПробегСГрузом = Истина;
		ПробегСГрузом           = Параметры.ПробегСГрузом;
		ПробегПорожний          = Параметры.ПробегПорожний;
	Иначе
		ОтображатьПробегСГрузом            = Ложь;
		Элементы.ПробегСГрузом.Видимость   = Ложь;
		Элементы.ПробегПорожний.Видимость  = Ложь;
	КонецЕсли;
	
	Если Не ОтображатьСтоимость Тогда 
		Элементы.ГруппаСтоимостьГруза.Видимость = Ложь;
	ИначеЕсли Не ОтображатьВалюту Тогда 
		Элементы.ВалютаТоваров.Видимость = Ложь;
	КонецЕсли;
	
	ВремяОбщее = уатЗащищенныеФункцииСервер.СложитьВремя(ВремяВПути, ВремяСтоянок);
	
	Если Параметры.Свойство("ТолькоПросмотр") И Параметры.ТолькоПросмотр = Истина Тогда
		Элементы.ГруппаПробег.ТолькоПросмотр                  = Истина;
		Элементы.ГруппаВремя.ТолькоПросмотр                   = Истина;
		Элементы.ГруппаВесОбъем.ТолькоПросмотр                = Истина;
		Элементы.ГруппаСтоимостьГруза.ТолькоПросмотр          = Истина;
		Элементы.ГруппаДополнительнаяВыработка.ТолькоПросмотр = Истина;
		Элементы.ФормаСохранитьДанные.Видимость               = Ложь;
		Элементы.ДобавитьДопВыработку.Видимость               = Ложь;
	КонецЕсли;
	
	ЗаголовокРеквизитаКоличествоМест = Справочники.уатВидыУпаковки_уэ.ПолучитьОсновнойВидУпаковки().КраткоеНаименование;
	Элементы.КоличествоМест.Заголовок = ЗаголовокРеквизитаКоличествоМест;
	
	ПредставлениеЕдиницыИзмеренияВеса = уатОбщегоНазначенияПовтИсп.ПолучитьПредставлениеОсновнойЕдиницыИзмеренияВеса();
	Если ЗначениеЗаполнено(ПредставлениеЕдиницыИзмеренияВеса) Тогда
		Элементы.ВесБрутто.Заголовок = НСтр("en='Weight';ru='Вес'") + ", " + ПредставлениеЕдиницыИзмеренияВеса;
		Элементы.ВесТары.Заголовок = НСтр("en='Tare weight';ru='Вес тары'") + ", " + ПредставлениеЕдиницыИзмеренияВеса;
	КонецЕсли;
	
	ПредставлениеЕдиницыИзмеренияОбъема = уатОбщегоНазначенияПовтИсп.ПолучитьПредставлениеОсновнойЕдиницыИзмеренияОбъема();
	Если ЗначениеЗаполнено(ПредставлениеЕдиницыИзмеренияОбъема) Тогда
		Элементы.Объем.Заголовок = НСтр("en='Volume';ru='Объем'") + ", " + ПредставлениеЕдиницыИзмеренияОбъема;
	КонецЕсли;
	
	ОтображатьПланФакт = Ложь;
	Если ВидДокумента = "уатМаршрутныйЛист" Тогда
		Элементы.ГруппаДополнительнаяВыработка.Видимость = Ложь;
		Если Не ПравоДоступа("Редактирование", Метаданные.Документы.уатМаршрутныйЛист) Тогда
			Элементы.ФормаСохранитьДанные.Видимость = Ложь;
		КонецЕсли;
		Если Параметры.Свойство("Организация") И ЗначениеЗаполнено(Параметры.Организация) Тогда
			ОтображатьПланФакт = Константы.уатУчетПланФактаПоМаршрутуВМаршрутныхЛистах.Получить();
		КонецЕсли;
	КонецЕсли;
	
	//Элементы.ГруппаПробегПлан.Видимость        = ОтображатьПланФакт;
	//Элементы.ГруппаВремяПлан.Видимость         = ОтображатьПланФакт;
	//Элементы.ДекорацияПробегФакт.Видимость     = ОтображатьПланФакт;
	//Элементы.ДекорацияВремяФакт.Видимость      = ОтображатьПланФакт;
	Элементы.ВыработкаКоличествоПлан.Видимость = ОтображатьПланФакт;
	Элементы.ВыработкаКоличествоФакт.Заголовок = ?(ОтображатьПланФакт, "Количество (факт)", "Количество");
	
	ОтобразитьДопВыработкуПриОткрытииФормы();
	ОтобразитьВыработкуПриОткрытииФормы();
	
	// сброс настроек размеров формы и положения окна до стандартны
	КлючОбъекта = "ОбщаяФорма.уатРедактированиеМаршрутныхПоказателей.Форма.Форма/НастройкиОкна";
	ХранилищеСистемныхНастроек.Удалить(КлючОбъекта,"", ИмяПользователя());
	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);	
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВремяВПутиПриИзменении(Элемент)
	
	ВремяОбщее = уатЗащищенныеФункцииСервер.СложитьВремя(ВремяВПути, ВремяСтоянок);
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяСтоянокПриИзменении(Элемент)
	
	ВремяОбщее = уатЗащищенныеФункцииСервер.СложитьВремя(ВремяВПути, ВремяСтоянок);
	
КонецПроцедуры

&НаКлиенте
Процедура ПробегСГрузомПриИзменении(Элемент)
	
	Расстояние = ПробегСГрузом + ПробегПорожний;
	
КонецПроцедуры

&НаКлиенте
Процедура ПробегПорожнийПриИзменении(Элемент)
	
	Расстояние = ПробегСГрузом + ПробегПорожний;
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрВыработкиПриИзменении(Элемент)
	
	ТекНомерВыработки = Число(Сред(Элемент.Имя, СтрДлина("ПараметрВыработки")+1));
	ПараметрВыработкиПриИзмененииСервер(ТекНомерВыработки);
	
КонецПроцедуры

&НаСервере
Процедура ПараметрВыработкиПриИзмененииСервер(ТекНомерВыработки)
	
	НастроитьВидРеквизитаЗначениеДопВыработки(ТекНомерВыработки);
	
	ТекПараметрВыработки = ЭтотОбъект["ПараметрВыработки" + Формат(ТекНомерВыработки, "ЧГ=")];
	Если ТекПараметрВыработки.СпособВводаЗначений = Перечисления.уатСпособыВводаЗначенийВыработкивМЛ_уэ.ВТабличнойЧасти Тогда
		ЭтотОбъект["ПараметрВыработкиЗначение" + Формат(ТекНомерВыработки, "ЧГ=")] = 0;
	КонецЕсли;
	
	Если ТекПараметрВыработки = ПарамВыработки1 Тогда
		ЭтотОбъект["ПараметрВыработкиЗначение" + Формат(ТекНомерВыработки, "ЧГ=")] = Выработка1;
	ИначеЕсли ТекПараметрВыработки = ПарамВыработки2 Тогда
		ЭтотОбъект["ПараметрВыработкиЗначение" + Формат(ТекНомерВыработки, "ЧГ=")] = Выработка2;
	КонецЕсли;
	
	Если ВидДокумента = "уатМаршрутныйЛист" Тогда
		КоличПараметрыТЧ = 0;
		Для Сч = 1 По МаксНомерДопВыработки Цикл
			Если Элементы.Найти("ГруппаПараметрВыработки" + Формат(Сч, "ЧГ=")) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ТекПараметрВыработки = ЭтотОбъект["ПараметрВыработки" + Формат(Сч, "ЧГ=")];
			Если ТекПараметрВыработки.СпособВводаЗначений = Перечисления.уатСпособыВводаЗначенийВыработкивМЛ_уэ.ВТабличнойЧасти Тогда
				КоличПараметрыТЧ = КоличПараметрыТЧ + 1;
			КонецЕсли;
		КонецЦикла;
		
		Если КоличПараметрыТЧ > 2 Тогда
			ЭтотОбъект["ПараметрВыработки" + Формат(ТекНомерВыработки, "ЧГ=")] = Неопределено;
			ТекстОшибки = НСтр("en='It is unacceptable to specify more than 2 output parameters with the input method ""In tabular section"".';ru='Недопустимо указание более 2 параметров выработки со способом ввода ""В табличной части"".'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		КонецЕсли;
	КонецЕсли;
	
	УстановитьДоступностьДопВыработки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрВыработкиЗначениеПриИзменении(Элемент)
	
	Сч = Число(Сред(Элемент.Имя, СтрДлина("ПараметрВыработкиЗначение")+1));
	Если уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(ЭтотОбъект["ПараметрВыработки" + Сч], "Временный") Тогда
		уатЗащищенныеФункцииСервер.КонтрольВводаВремени(ЭтотОбъект["ПараметрВыработкиЗначение" + Сч]);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийТаблицыВыработка

&НаКлиенте
Процедура ВыработкаПередУдалением(Элемент, Отказ)
	ТекСтрока = Элементы.Выработка.ТекущиеДанные;
	Если НЕ ТекСтрока.РучнойВвод Тогда
		ТекстСообщ = "Запрещено удаление предопределенной выработки.";
		уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстСообщ, Отказ);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьДопВыработку(Команда)
	
	ДобавитьДопВыработкуСервер(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьДопВыработку(Команда)
	
	Если ТекущийЭлемент = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если Лев(ТекущийЭлемент.Имя, СтрДлина("ПараметрВыработкиУдалить")) = "ПараметрВыработкиУдалить" Тогда 
		УдалитьДопВыработкуСервер(Число(Прав(ТекущийЭлемент.Имя, СтрДлина(ТекущийЭлемент.Имя) - СтрДлина("ПараметрВыработкиУдалить"))));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДанные(Команда)
	
	ПараметрыЗакрытия = Новый Структура();
	ПараметрыЗакрытия.Вставить("Расстояние",     Расстояние);
	ПараметрыЗакрытия.Вставить("ВремяВПути",     ВремяВПути);
	ПараметрыЗакрытия.Вставить("ВесБрутто",      ВесБрутто);
	ПараметрыЗакрытия.Вставить("Объем",          Объем);
	ПараметрыЗакрытия.Вставить("КоличествоМест", КоличествоМест);
	
	Если ОтображатьВремяСтоянок Тогда 
		ПараметрыЗакрытия.Вставить("ВремяСтоянок", ВремяСтоянок);
	КонецЕсли;
	
	Если ОтображатьСтоимость Тогда 
		ПараметрыЗакрытия.Вставить("СтоимостьГруза", СтоимостьГруза);
	КонецЕсли;
	
	Если ОтображатьВалюту Тогда 
		ПараметрыЗакрытия.Вставить("ВалютаТоваров", ВалютаТоваров);
	КонецЕсли;
	
	Если ОтображатьПробегСГрузом Тогда 
		ПараметрыЗакрытия.Вставить("ПробегСГрузом",  ПробегСГрузом);
		ПараметрыЗакрытия.Вставить("ПробегПорожний", ПробегПорожний);
	КонецЕсли;
	
	мсвДопВыработка = Новый Массив;
	Если КоличествоДопВыработки > 0 Тогда
		Для Сч = 1 По МаксНомерДопВыработки Цикл
			Если Элементы.Найти("ГруппаПараметрВыработки" + Формат(Сч, "ЧГ=")) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ТекПараметрВыработки = ЭтотОбъект["ПараметрВыработки" + Сч];
			ТекЗначениеВыработки = ЭтотОбъект["ПараметрВыработкиЗначение" + Сч];
			
			Если уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(ТекПараметрВыработки, "Временный") Тогда
				ТекЗначениеВыработки = уатОбщегоНазначения.уатВремяВСекунды(ТекЗначениеВыработки)/3600;
			КонецЕсли;
			
			мсвДопВыработка.Добавить(Новый Структура("ПараметрВыработки, Значение", ТекПараметрВыработки, ТекЗначениеВыработки));
		КонецЦикла;
	КонецЕсли;
	ПараметрыЗакрытия.Вставить("ДопВыработка", мсвДопВыработка);
	
	мсвВыработкаТСиСотрудников = Новый Массив;
	Для Каждого ТекСтрока Из Выработка Цикл
		мсвВыработкаТСиСотрудников.Добавить(Новый Структура("ПараметрВыработки, КоличествоПлан, КоличествоФакт",
			ТекСтрока.ПараметрВыработки, ТекСтрока.КоличествоПлан, ТекСтрока.КоличествоФакт));
	КонецЦикла;
	ПараметрыЗакрытия.Вставить("ВыработкаТСиСотрудников", мсвВыработкаТСиСотрудников);
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область ДопВыработкаСтарое

&НаСервере
Процедура ОтобразитьДопВыработкуПриОткрытииФормы()
	
	Если Не Параметры.Свойство("ДопВыработка") Тогда
		Возврат;
	КонецЕсли;
	
	// Добавление реквизитов формы.
	ДопВыработка = Параметры.ДопВыработка;
	
	Если Ложь Тогда // Отключено заполнение.
		ДобавитьОстальныеПараметрыВыработки(ДопВыработка);
	КонецЕсли;
	
	Сч = 1;
	ДопРеквизиты = Новый Массив();
	Для Каждого ТекДопВыработка Из ДопВыработка Цикл
		ТекРеквизитПараметр = Новый РеквизитФормы("ПараметрВыработки" + Формат(Сч, "ЧГ="),
			Новый ОписаниеТипов("СправочникСсылка.уатПараметрыВыработки"));
		ТекРеквизитЗначение = Новый РеквизитФормы("ПараметрВыработкиЗначение" + Формат(Сч, "ЧГ="),
			Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 3, ДопустимыйЗнак.Неотрицательный)));
		
		ДопРеквизиты.Добавить(ТекРеквизитПараметр);
		ДопРеквизиты.Добавить(ТекРеквизитЗначение);
		
		Сч = Сч + 1;
	КонецЦикла;
	
	ИзменитьРеквизиты(ДопРеквизиты);
	
	// Заполняем значения доп. выработки, введенные в документе.
	Сч = 1;
	Для Каждого ТекДопВыработка Из ДопВыработка Цикл
		ДобавитьДопВыработкуСервер(Ложь, Сч, ТекДопВыработка);
		Сч = Сч + 1;
	КонецЦикла;
	
	КоличествоДопВыработки = Сч - 1;
	МаксНомерДопВыработки  = КоличествоДопВыработки;
	
	УстановитьДоступностьДопВыработки();
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьОстальныеПараметрыВыработки(ДопВыработка)
	
	мсвПараметрыИскл = Новый Массив();
	КоличТабл = 0;
	Для Каждого ТекВыр Из ДопВыработка Цикл
		мсвПараметрыИскл.Добавить(ТекВыр.ПараметрВыработки);
		Если ТекВыр.ПараметрВыработки.СпособВводаЗначений = Перечисления.уатСпособыВводаЗначенийВыработкивМЛ_уэ.ВТабличнойЧасти Тогда
			КоличТабл = КоличТабл + 1;
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("мсвПараметрыИскл", мсвПараметрыИскл);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатПараметрыВыработки.Ссылка,
	|	уатПараметрыВыработки.СпособВводаЗначений = ЗНАЧЕНИЕ(Перечисление.уатСпособыВводаЗначенийВыработкивМЛ_уэ.ВТабличнойЧасти) КАК ВТабличнойЧасти
	|ИЗ
	|	Справочник.уатПараметрыВыработки КАК уатПараметрыВыработки
	|ГДЕ
	|	(уатПараметрыВыработки.ИспользоватьДляМаршрутныхЛистов = &ИспользоватьДляМаршрутныхЛистов И уатПараметрыВыработки.ДействуетНаТСМЛ = &ИспользоватьДляМаршрутныхЛистов
	|	ИЛИ уатПараметрыВыработки.ИспользоватьДляЗаказовИПотребности = &ИспользоватьДляЗаказовИПотребности)
	|	И НЕ уатПараметрыВыработки.Предопределенный
	|	И НЕ уатПараметрыВыработки.ПометкаУдаления
	|	И НЕ уатПараметрыВыработки.Ссылка В (&мсвПараметрыИскл)";
	
	Если ВидДокумента = "уатМаршрутныйЛист" ИЛИ ВидДокумента = "уатЗаказПеревозчику_уэ" И НЕ ЗаказПеревозчику_ПоЗаказам Тогда
		Запрос.УстановитьПараметр("ИспользоватьДляМаршрутныхЛистов", Истина);
	Иначе
		Запрос.УстановитьПараметр("ИспользоватьДляМаршрутныхЛистов", Ложь);
	КонецЕсли;
	
	Если ВидДокумента = "уатЗаказГрузоотправителя" Или ВидДокумента = "уатПотребностьВПеревозке_уэ"
			Или ВидДокумента = "уатЗаказПеревозчику_уэ" И ЗаказПеревозчику_ПоЗаказам Тогда
		Запрос.УстановитьПараметр("ИспользоватьДляЗаказовИПотребности", Истина);
	Иначе
		Запрос.УстановитьПараметр("ИспользоватьДляЗаказовИПотребности", Ложь);
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.ВТабличнойЧасти Тогда
			Если КоличТабл >= 2 Тогда
				Продолжить;
			Иначе
				КоличТабл = КоличТабл + 1;
			КонецЕсли;
		КонецЕсли;
		
		ДопВыработка.Добавить(Новый Структура("ПараметрВыработки, Значение", Выборка.Ссылка, 0));
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьДопВыработкуСервер(флКнопкаДобавить, Сч = Неопределено, ТекДопВыработка = Неопределено)
	
	Если флКнопкаДобавить Тогда // Добавление нового параметра выработки - новый реквизиты формы
		ДопРеквизиты = Новый Массив;
		
		Сч = МаксНомерДопВыработки + 1;
		
		ТекРеквизитПараметр = Новый РеквизитФормы("ПараметрВыработки" + Формат(Сч, "ЧГ="),
			Новый ОписаниеТипов("СправочникСсылка.уатПараметрыВыработки"));
		ТекРеквизитЗначение = Новый РеквизитФормы("ПараметрВыработкиЗначение" + Формат(Сч, "ЧГ="),
			Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 3, ДопустимыйЗнак.Неотрицательный)));
		
		ДопРеквизиты.Добавить(ТекРеквизитПараметр);
		ДопРеквизиты.Добавить(ТекРеквизитЗначение);
		
		ИзменитьРеквизиты(ДопРеквизиты);
		
	Иначе // Реквизиты уже добавлены, заполняем значение параметра выработки и выработку
		ЭтотОбъект["ПараметрВыработки" + Сч] = ТекДопВыработка.ПараметрВыработки;
		
		// заполняем значение выработки
		Если ТекДопВыработка.ПараметрВыработки = ПарамВыработки1 Тогда
			ЭтотОбъект["ПараметрВыработкиЗначение" + Сч] = Выработка1;
		ИначеЕсли ТекДопВыработка.ПараметрВыработки = ПарамВыработки2 Тогда
			ЭтотОбъект["ПараметрВыработкиЗначение" + Сч] = Выработка2;
		Иначе
			Если ТекДопВыработка.ПараметрВыработки.Временный Тогда
				ЭтотОбъект["ПараметрВыработкиЗначение" + Сч] = уатОбщегоНазначения.уатВремяВЧЧ_ММ(ТекДопВыработка.Значение*3600);
			Иначе
				ЭтотОбъект["ПараметрВыработкиЗначение" + Сч] = ТекДопВыработка.Значение;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
		
	// Добавление группы параметра выработки
	ТекГруппа = Элементы.Добавить("ГруппаПараметрВыработки" + Формат(Сч, "ЧГ="), Тип("ГруппаФормы"), Элементы.ГруппаДополнительнаяВыработка);
	ТекГруппа.Вид                 = ВидГруппыФормы.ОбычнаяГруппа;
	ТекГруппа.Группировка         = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	ТекГруппа.Отображение         = ОтображениеОбычнойГруппы.Нет;
	ТекГруппа.ОтображатьЗаголовок = Ложь;
	ТекГруппа.Ширина = 46;
	ТекГруппа.РастягиватьПоГоризонтали = Ложь;
	
	// Добавление поля ввода параметра выработки
	ТекЭлемент = Элементы.Добавить("ПараметрВыработки" + Формат(Сч, "ЧГ="), Тип("ПолеФормы"), ТекГруппа);
	ТекЭлемент.ПутьКДанным              = "ПараметрВыработки" + Формат(Сч, "ЧГ=");
	ТекЭлемент.Вид                      = ВидПоляФормы.ПолеВвода;
	ТекЭлемент.ПоложениеЗаголовка       = ПоложениеЗаголовкаЭлементаФормы.Нет;
	ТекЭлемент.РастягиватьПоГоризонтали = Ложь;
	ТекЭлемент.Ширина                   = 20;
	ТекЭлемент.ИсторияВыбораПриВводе    = ИсторияВыбораПриВводе.НеИспользовать;
	ТекЭлемент.УстановитьДействие("ПриИзменении", "ПараметрВыработкиПриИзменении");
	
	// Отбор выбора параметров выработки по использованию в документах
	мсвПараметрыВыбора = Новый Массив();
	Если ВидДокумента = "уатМаршрутныйЛист" ИЛИ ВидДокумента = "уатЗаказПеревозчику_уэ" И НЕ ЗаказПеревозчику_ПоЗаказам Тогда
		мсвПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.ИспользоватьДляМаршрутныхЛистов", Истина));
		
	ИначеЕсли ВидДокумента = "уатЗаказГрузоотправителя" Или ВидДокумента = "уатПотребностьВПеревозке_уэ" 
			Или (ВидДокумента = "уатЗаказПеревозчику_уэ" И ЗаказПеревозчику_ПоЗаказам) Тогда
		мсвПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.ИспользоватьДляЗаказовИПотребности", Истина));
	КонецЕсли;
	ТекЭлемент.ПараметрыВыбора = Новый ФиксированныйМассив(мсвПараметрыВыбора);
	
	// Добавление поля ввода значения выработки
	ТекЭлемент = Элементы.Добавить("ПараметрВыработкиЗначение" + Формат(Сч, "ЧГ="), Тип("ПолеФормы"), ТекГруппа);
	НастроитьВидРеквизитаЗначениеДопВыработки(Сч);
	
	// Добавление кнопки "Удалить выработку"
	Если Элементы.ГруппаДополнительнаяВыработка.Видимость
		И НЕ Элементы.ГруппаДополнительнаяВыработка.ТолькоПросмотр Тогда
		ТекЭлемент = Элементы.Добавить("ПараметрВыработкиУдалить" + Формат(Сч, "ЧН=0; ЧГ=0"), Тип("КнопкаФормы"), ТекГруппа);
		ТекЭлемент.ИмяКоманды               = "УдалитьДопВыработку";
		ТекЭлемент.Ширина                   = 3;
		ТекЭлемент.Высота                   = 1;
		ТекЭлемент.РастягиватьПоГоризонтали = Ложь;
		ТекЭлемент.РастягиватьПоВертикали   = Ложь;
		ТекЭлемент.ГоризонтальноеПоложениеВГруппе = ГоризонтальноеПоложениеЭлемента.Право;
	КонецЕсли;
			
	Если флКнопкаДобавить Тогда
		КоличествоДопВыработки = КоличествоДопВыработки + 1;
		МаксНомерДопВыработки  = МаксНомерДопВыработки  + 1;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура НастроитьВидРеквизитаЗначениеДопВыработки(НомерПараметраВыработки)
	
	ТекПараметрВыработки = ЭтаФорма["ПараметрВыработки" + Формат(НомерПараметраВыработки, "ЧГ=")];
	
	ЭлементФормыЗначениеДопВыработки = Элементы["ПараметрВыработкиЗначение" + Формат(НомерПараметраВыработки, "ЧГ=")];
	Если ЭлементФормыЗначениеДопВыработки.ПутьКДанным = "" Тогда
		ЭлементФормыЗначениеДопВыработки.ПутьКДанным          = "ПараметрВыработкиЗначение" + Формат(НомерПараметраВыработки, "ЧГ=");
	КонецЕсли;
	ЭлементФормыЗначениеДопВыработки.ПоложениеЗаголовка       = ПоложениеЗаголовкаЭлементаФормы.Нет;
	ЭлементФормыЗначениеДопВыработки.УстановитьДействие("ПриИзменении", "ПараметрВыработкиЗначениеПриИзменении");
	
	Если ТекПараметрВыработки.ОтображениеВВидеФлага Тогда
		ЭлементФормыЗначениеДопВыработки.Вид                     = ВидПоляФормы.ПолеПереключателя;
		ЭлементФормыЗначениеДопВыработки.ВидПереключателя        = ВидПереключателя.Тумблер;
		ЭлементФормыЗначениеДопВыработки.ОдинаковаяШиринаКолонок = Истина;
		ЭлементФормыЗначениеДопВыработки.СписокВыбора.Очистить();
		ЭлементФормыЗначениеДопВыработки.СписокВыбора.Добавить(1, "Да");
		ЭлементФормыЗначениеДопВыработки.СписокВыбора.Добавить(0, "Нет");
	Иначе
		ЭлементФормыЗначениеДопВыработки.Вид    = ВидПоляФормы.ПолеВвода;
		ЭлементФормыЗначениеДопВыработки.Ширина = 12;
		ЭлементФормыЗначениеДопВыработки.РастягиватьПоГоризонтали = Ложь;
	КонецЕсли;
	
	// форматирование временного показателя
	Если ТекПараметрВыработки.Временный Тогда
		ЭлементФормыЗначениеДопВыработки.ФорматРедактирования = "ЧДЦ=2; ЧРД=:; ЧГ=";
		ЭлементФормыЗначениеДопВыработки.КнопкаВыбора = Ложь;
	ИначеЕсли НЕ ТекПараметрВыработки.ОтображениеВВидеФлага Тогда
		ЭлементФормыЗначениеДопВыработки.ФорматРедактирования = "";
		ЭлементФормыЗначениеДопВыработки.КнопкаВыбора = Неопределено;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура УдалитьДопВыработкуСервер(НомерПараметраВыработки)
	
	Элементы.Удалить(Элементы["ПараметрВыработкиУдалить" + Формат(НомерПараметраВыработки, "ЧГ=")]);
	Элементы.Удалить(Элементы["ПараметрВыработкиЗначение" + Формат(НомерПараметраВыработки, "ЧГ=")]);
	Элементы.Удалить(Элементы["ПараметрВыработки" + Формат(НомерПараметраВыработки, "ЧГ=")]);
	Элементы.Удалить(Элементы["ГруппаПараметрВыработки" + Формат(НомерПараметраВыработки, "ЧГ=")]);
	
	ДопРеквизиты = Новый Массив();
	ДопРеквизиты.Добавить("ПараметрВыработки" + Формат(НомерПараметраВыработки, "ЧГ="));
	ДопРеквизиты.Добавить("ПараметрВыработкиЗначение" + Формат(НомерПараметраВыработки, "ЧГ="));
	
	ИзменитьРеквизиты(, ДопРеквизиты);
	
	// Если удалили не последний параметр выработки, то нужно их отсортировать.
	ТекНомер = 1;
	Для Сч = 1 По МаксНомерДопВыработки Цикл
		ЭлементНадпись = Элементы.Найти("НадписьПараметрВыработки" + Формат(Сч, "ЧГ="));
		Если ЭлементНадпись = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Элементы["НадписьПараметрВыработки" + Формат(Сч, "ЧГ=")].Заголовок = НСтр("en='Parameter';ru='Параметр'") + " " + Формат(ТекНомер, "ЧГ=") + ":";
		ТекНомер = ТекНомер + 1;
	КонецЦикла;
	
	КоличествоДопВыработки = КоличествоДопВыработки - 1;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьДопВыработки()
	
	Для Сч = 1 По МаксНомерДопВыработки Цикл
		Если Элементы.Найти("ПараметрВыработки" + Формат(Сч, "ЧГ=")) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ТекПараметрВыработки = ЭтотОбъект["ПараметрВыработки" + Формат(Сч, "ЧГ=")];
		Если ВидДокумента = "уатМаршрутныйЛист" И ТекПараметрВыработки.ИспользоватьДляМаршрутныхЛистов
				И ТекПараметрВыработки.СпособВводаЗначений = Перечисления.уатСпособыВводаЗначенийВыработкивМЛ_уэ.ВТабличнойЧасти Тогда
			ДоступностьВыработки = Ложь;
		Иначе
			ДоступностьВыработки = Истина;
		КонецЕсли;
		
		Элементы["ПараметрВыработкиЗначение" + Формат(Сч, "ЧГ=")].Доступность = ДоступностьВыработки;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Выработка

&НаСервере
Процедура ОтобразитьВыработкуПриОткрытииФормы()
	
	Если Не Параметры.Свойство("ВыработкаТСиСотрудников") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекВыработка Из Параметры.ВыработкаТСиСотрудников Цикл
		НоваяСтрока = Выработка.Добавить();
		НоваяСтрока.ПараметрВыработки = ТекВыработка.ПараметрВыработки;
		НоваяСтрока.КоличествоПлан    = ТекВыработка.КоличествоПлан;
		НоваяСтрока.КоличествоФакт    = ТекВыработка.КоличествоФакт;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
